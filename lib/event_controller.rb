$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require 'sinatra/base'
require 'slack-ruby-client'

require 'bot'
require 'message_handler'
require 'tiny_logger'

class EventController < Sinatra::Base
  attr_reader :message_handler

  def initialize(app: nil, message_handler: nil)
    super(app)
    @message_handler = message_handler || create_message_handler
  end

  def create_message_handler
    MessageHandler.new(
      bot: Bot.new,
      user_info_provider: UserInfoProvider.new,
      mark_all_out: MarkAllOut.new
    )
  end

  post '/events' do
    request_data = JSON.parse(request.body.read)

    verify_token(request_data)
    verify_url(request_data)
    handle_event(request_data)

    status 200
  end

  private

  def verify_token(data)
    if invalid_token?(data['token'])
      halt 403, "Invalid Slack verification token received: #{data['token']}"
    end
  end

  def invalid_token?(token)
    !(ENV['SLACK_VERIFICATION_TOKEN'] == token)
  end

  def verify_url(data)
    body data['challenge'].to_s if data['type'] == 'url_verification'
  end

  def handle_event(data)
    if data['type'] == 'event_callback'
      team_id = data['team_id']
      event_data = data['event']

      if message?(event_data) && !message_from_bot?(event_data)
        Logger.info("Receives Data #{event_data}")
        message_handler.handle(team_id, event_data)
      end
    end
  end

  def message?(event_data)
    event_data['type'] == 'message'
  end

  def message_from_bot?(event_data)
    event_data['bot_id']
  end
end
