require 'models/user'
require 'commands/crafter/add_office'
require 'mark_all_out'
require 'request_parser'
require 'bot'
require 'tiny_logger'
require 'user_info_provider'
require 'feature_flag'

class MessageHandler < FeatureFlag
  release_for 'Fabien Townsend'

  def initialize(args = {})
    @mark_all_out = args[:mark_all_out] # TODO - this doesnt seem to be used here.
    @request_parser = RequestParser.new
    @bot = args[:bot]
    @user_info = args[:user_info_provider]
  end

  def handle(event_data)
    data = format(event_data)

    if hasnt_message?(data)
      return data[:user_message]
    end

    if hasnt_user?(data)
      User.create(data)
    end

    recipient = get_recipient(data)
    if hasnt_office?(data)
      @bot.send("You need to add your office. ex: \"office: london\"", recipient)
      return
    end

    command = @request_parser.parse(data)
    unless command.nil?
      response = run(command)
      @bot.send(response, recipient)
    end
  end

  private

  def get_recipient(data)
    data[:channel_id] || data[:user_id]
  end

  def hasnt_message?(data)
    data[:user_message].nil?
  end

  def hasnt_office?(data)
    !User.has_office?(data[:user_id]) && !Commands::AddOffice.add_office_request?(data)
  end

  def hasnt_user?(data)
    User.profile(data[:user_id]).nil?
  end

  def run(command)
    Logger.info("COMMAND RUN")
    response = command.run
    Logger.info("COMMAND RESPONSE: #{response}")
    response
  end

  def format(event_data)
    {
      user_message: event_data['text'],
      user_id: event_data['user'],
      user_name: @user_info.real_name(event_data['user']),
      user_email: @user_info.email(event_data['user']),
      channel_id: event_data['channel'],
      mark_all_out: @mark_all_out,
    }
  end
end
