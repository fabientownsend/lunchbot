# typed: false
$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require 'sinatra/base'
require 'slack-ruby-client'

require 'bot'
require 'message_handler'
require 'request'
require 'requester'
require 'tiny_logger'

class EventController < Sinatra::Base
  attr_reader :message_handler, :requester

  def initialize(app: nil, message_handler: nil, user_info_provider: UserInfoProvider.new)
    super(app)
    @message_handler = message_handler || create_message_handler
    @requester = SlackApi::Requester.new(slack_api_user: user_info_provider)
  end

  def create_message_handler
    MessageHandler.new(bot: Bot.new)
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

  post '/commands' do
    Logger.info("Slash command request body: #{request.body.read}")
    status 200
  end

  private

  def handle_event(data)
    requester.parse(data)
    Logger.info("Received data #{data['event']}")
    message_handler.handle(requester)
  end
end
