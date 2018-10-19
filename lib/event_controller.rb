$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require 'sinatra/base'
require 'slack-ruby-client'

require 'message_handler'
require 'tiny_logger'
require 'response'

class EventController < Sinatra::Base
  attr_reader :message_handler

  def initialize
    @message_handler = MessageHandler.new(response: Response.new.setup)
  end

  post '/events' do
    verify_token
    verify_url

    if okay_to_handle_event?
      handle_event
    end

    status 200
  end

  private

  def okay_to_handle_event?
    event_is_callback? && event_is_message? && !message_from_bot?
  end

  def verify_token
    if invalid_token?
      halt 403, "Invalid Slack verification token received: #{token}"
    end
  end

  def verify_url
    body request_data['challenge'].to_s if url_verification?
  end

  def handle_event
    begin
      Thread.new do
        Logger.info("Receives Data #{event}")
        @message_handler.handle(team_id, event)
      end
    rescue StandardError => error
      Logger.alert(error)
    end
  end

  def invalid_token?
    !SLACK_CONFIG[:slack_verification_token] == token
  end

  def url_verification?
    request_data['type'] == 'url_verification'
  end

  def handle_event
  end

  def event_is_callback?
    request_data['type'] == 'event_callback'
  end

  def event_is_message?
    event['type'] == 'message'
  end

  def message_from_bot?
    event['bot_id']
  end

  def token
    request_data['token']
  end

  def team_id
    request_data['team_id']
  end

  def event
    request_data['event']
  end

  def request_data
    JSON.parse(request.body.read)
  end
end
