require 'bot'
require 'commands/crafter/add_office'
require 'feature_flag'
require 'mark_all_out'
require 'models/user'
require 'request_parser'
require 'requester'
require 'tiny_logger'
require 'user_info_provider'

class MessageHandler < FeatureFlag
  release_for 'Fabien Townsend'

  def initialize(args = {})
    @mark_all_out = args[:mark_all_out]
    @request_parser = RequestParser.new
    @bot = args[:bot]
    @requester = SlackApi::Requester.new(slack_api_user: args[:user_info_provider])
  end

  def handle(event_data)
    requester.parse('event' => event_data)
    return unless requester.has_message?
    recipient = event_data['channel'] || event_data['user']

    data = format_data(event_data)
    returned_command = @request_parser.parse(data)

    unless User.profile(requester.id)
      User.create(data)
    end

    if !User.has_office?(requester.id) && !Commands::AddOffice.add_office_request?(data)
      @bot.send("You need to add your office. ex: \"office: london\"", recipient)
      return
    end

    unless returned_command.nil?
      response = deal_with_command(returned_command)
      @bot.send(response, recipient)
    end
  end

  private

  attr_reader :requester

  def deal_with_command(command)
    Logger.info("COMMAND RUN")
    response = command.run
    Logger.info("COMMAND RESPONSE: #{response}")
    response
  end

  def format_data(event_data)
    {
      user_message: requester.message,
      user_id: requester.id,
      user_name: requester.name,
      user_email: requester.email,
      mark_all_out: @mark_all_out,
    }
  end
end
