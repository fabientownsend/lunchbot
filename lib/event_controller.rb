$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require 'sinatra/base'
require 'slack-ruby-client'

require 'message_handler'
require 'tiny_logger'

class EventController < Sinatra::Base
  attr_reader :message_handler

  def initialize
    @message_handler = MessageHandler.new
  end

  post '/events' do
    verify_token
    verify_url
    spawn_new_event_handler
    status 200
  end

  private

  def verify_token
    if invalid_token?
      halt 403, "Invalid Slack verification token received: #{token}"
    end
  end

  def verify_url
    body request_data['challenge'].to_s if url_verification?
  end

  def spawn_new_event_handler
    begin
      Thread.new { handle_event }
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
    if event_callback?
      if message? && !message_from_bot?
        Logger.info("Receives Data #{event}")
        @message_handler.handle(team_id, event)
      end
    end
  end

  def event_callback?
    request_data['type'] == 'event_callback'
  end

  def message?
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
