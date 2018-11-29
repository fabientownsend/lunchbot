$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require 'sinatra/base'
require 'slack-ruby-client'

require 'bot'
require 'request'
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
    request = SlackApi::Request.new(request_data)

    if !request.valid_token?
      halt 403, "Invalid Slack verification token received"
    end

    if request.url_verification?
      body request_data['challenge'].to_s
    end

    if request.requires_answer?
      handle_event(request_data)
    end

    status 200
  end

  private

  def handle_event(data)
    Logger.info("Received data #{data['event']}")
    message_handler.handle(data['event'])
  end
end
