require 'sinatra/base'
require 'slack-ruby-client'
require_relative 'message_handler'
<<<<<<< HEAD

class EventController < Sinatra::Base
=======
require_relative 'menu'

class EventController < Sinatra::Base
  def initialize
    @menu = Menu.new
  end

>>>>>>> 59ee66deb69c2dcbfc723a2379a09a3be64a860e
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
<<<<<<< HEAD
          MessageHandler.handle(team_id, event_data)
=======
          MessageHandler.handle(team_id, event_data, @menu)
>>>>>>> 59ee66deb69c2dcbfc723a2379a09a3be64a860e
      end
    end
  end

  def verify_token(data)
    if !SLACK_CONFIG[:slack_verification_token] == data['token']
      halt 403, "Invalid Slack verification token received: #{data['token']}"
    end
  end
end
