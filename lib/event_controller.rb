$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'message_handler'
require 'sinatra/base'
require 'slack-ruby-client'

class EventController < Sinatra::Base
  attr_reader :message_handler
  def initialize()
    @message_handler = MessageHandler.new
  end

  post '/events' do
    request_data = JSON.parse(request.body.read)

    verify_token(request_data)
    verify_url(request_data)
    handle_event(request_data)

    status 200
  end

  def verify_url(data)
    if data['type'] == 'url_verification'
      data['challenge']
    end
  end

  def handle_event(data)
    if data['type'] == 'event_callback'
      team_id = data['team_id']
      event_data = data['event']

      if event_data['type'] == 'message'
        unless event_data['user'] == $teams[team_id][:bot_user_id]
          @message_handler.handle(team_id, event_data)
        end
      end
    end
  end

  def verify_token(data)
    if !SLACK_CONFIG[:slack_verification_token] == data['token']
      halt 403, "Invalid Slack verification token received: #{data['token']}"
    end
  end
end
