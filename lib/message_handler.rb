require 'alert_foreman'
require 'foreman_messager'
require 'mark_all_out'
require 'request_parser'
require 'response'
require 'tiny_logger'
require 'user_info_provider'

class MessageHandler
  def initialize(args = {})
    @mark_all_out = args[:mark_all_out] || MarkAllOut.new
    @request_parser = RequestParser.new
    if args[:response]
      @response = args[:response]
    else
      @response = Response.new
      @response.setup
    end
    @user_info = args[:user_info_provider] || UserInfoProvider.new
    @foreman_messager = ForemanMessager.new
    @alert = AlertForeman.new(@foremanMessager)
  end

  def handle(team_id, event_data)
    @foreman_messager.update_team_id(team_id)
    data = format_data(team_id, event_data)
    return data[:user_message] if data[:user_message].nil?
    returned_command = @request_parser.parse(data)
    deal_with_command(returned_command, event_data) unless returned_command.nil?
  end

  private

  def deal_with_command(command, event_data)
    Logger.info("COMMAND RUN")
    response = command.run
    Logger.info("COMMAND RESPONSE: #{response}")
    channel = event_data['channel'] || event_data['user']
    respond(response, event_data['user'], channel)
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

  def respond(bot_answer, user_id, channel)
    @response.send(bot_answer, channel)
  end
end
