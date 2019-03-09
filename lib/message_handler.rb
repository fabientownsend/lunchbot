require 'bot'
require 'commands/crafter/add_office'
require 'models/user'
require 'request_parser'
require 'requester'
require 'tiny_logger'

class MessageHandler
  def initialize(args = {})
    @request_parser = RequestParser.new
    @bot = args[:bot]
  end

  def handle(requester)
    return unless requester.has_message?

    formated_data = format(requester)

    unless User.profile(requester.id)
      User.create(formated_data)
    end

    return if !request_parser.find_command?(formated_data)
    returned_command = request_parser.parse(formated_data)

    if !User.has_office?(requester.id) &&
       !Commands::AddOffice.add_office_request?(formated_data) &&
      bot.send("You need to add your office. ex: \"office: london\"", requester.recipient)
      return
    end

    response = deal_with_command(returned_command)
    bot.send(response, requester.recipient)
  end

  private

  attr_reader :requester, :bot, :request_parser

  def deal_with_command(command)
    Logger.info("COMMAND RUN")
    response = command.run
    Logger.info("COMMAND RESPONSE: #{response}")
    response
  end

  def format(requester)
    {
      user_message: requester.message,
      user_id: requester.id,
      user_name: requester.name,
      user_email: requester.email,
    }
  end
end
