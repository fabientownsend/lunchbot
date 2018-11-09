require 'models/crafter'
require 'commands/crafter/add_office'
require 'alert_foreman'
require 'foreman_messager'
require 'mark_all_out'
require 'request_parser'
require 'bot'
require 'tiny_logger'
require 'user_info_provider'
require 'feature_flag'

class MessageHandler < FeatureFlag
  release_for 'Fabien Townsend'

  def initialize(args = {})
    @mark_all_out = args[:mark_all_out]
    @request_parser = RequestParser.new
    @bot = args[:bot]
    @user_info = args[:user_info_provider]
    @foreman_messager = ForemanMessager.new(@bot)
    @alert = AlertForeman.new(@foremanMessager)
  end

  def handle(team_id, event_data)
    recipient = event_data['channel'] || event_data['user']
    @foreman_messager.update_team_id(team_id)
    data = format_data(team_id, event_data)
    return data[:user_message] if data[:user_message].nil?
    returned_command = @request_parser.parse(data)

    unless Crafter.profile(data[:user_id])
      Crafter.create(data)
    end

    if !Crafter.has_office?(data[:user_id]) && !Commands::AddOffice.add_office_request?(data)
      @bot.send("You need to add your office. ex: \"office: london\"", recipient)
      return
    end

    unless returned_command.nil?
      response = deal_with_command(returned_command)
      @bot.send(response, recipient)
    end
  end

  private

  def deal_with_command(command)
    Logger.info("COMMAND RUN")
    response = command.run
    Logger.info("COMMAND RESPONSE: #{response}")
    response
  end

  def format_data(team_id, event_data)
    {
      user_message: event_data['text'],
      user_id: event_data['user'],
      user_name: @user_info.real_name(event_data['user']),
      user_email: @user_info.email(event_data['user']),
      channel_id: event_data['channel'],
      team_id: team_id,
      mark_all_out: @mark_all_out,
      alert: @alert,
    }
  end
end
