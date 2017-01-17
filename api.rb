require 'sinatra/base'
require 'slack-ruby-client'
require_relative 'event_handler'

class API < Sinatra::Base
  post '/events' do
    request_data = JSON.parse(request.body.read)
    puts "request: #{request_data}"

    unless SLACK_CONFIG[:slack_verification_token] == request_data['token']
      halt 403, "Invalid Slack verification token received: #{request_data['token']}"
    end

    case request_data['type']
      when 'url_verification'
        request_data['challenge']

      when 'event_callback'
        team_id = request_data['team_id']
        event_data = request_data['event']

        if event_data['type'] == 'message'
            EventHandler.message(team_id, event_data)
        end

        status 200
    end
  end
end
