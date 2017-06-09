require 'sinatra/base'
require 'slack-ruby-client'
require_relative 'models/auth_info'

SLACK_CONFIG = {
  slack_client_id: ENV['SLACK_CLIENT_ID'],
  slack_api_secret: ENV['SLACK_API_SECRET'],
  slack_redirect_uri: ENV['SLACK_REDIRECT_URI'],
  slack_verification_token: ENV['SLACK_VERIFICATION_TOKEN']
}

missing_params = SLACK_CONFIG.select { |key, value| value.nil? }
if missing_params.any?
  error_msg = missing_params.keys.join(", ").upcase
  raise "Missing Slack config variables: #{error_msg}"
end

BOT_SCOPE = 'bot'

$teams = {}

def create_slack_client(slack_api_secret)
  Slack.configure do |config|
    config.token = slack_api_secret
    fail 'Missing API token' unless config.token
  end
  Slack::Web::Client.new
end

class Auth < Sinatra::Base
  add_to_slack_button = %(
    <a href=\"https://slack.com/oauth/authorize?scope=#{BOT_SCOPE}&client_id=#{SLACK_CONFIG[:slack_client_id]}&redirect_uri=#{SLACK_CONFIG[:redirect_uri]}\">
      <img alt=\"Add to Slack\" height=\"40\" width=\"139\" src=\"https://platform.slack-edge.com/img/add_to_slack.png\"/>
    </a>
  )

  get '/' do
    redirect '/begin_auth'
  end

  get '/begin_auth' do
    status 200
    body add_to_slack_button
  end

  get '/finish_auth' do
    client = Slack::Web::Client.new
    begin
      response = client.oauth_access(
        {
          client_id: SLACK_CONFIG[:slack_client_id],
          client_secret: SLACK_CONFIG[:slack_api_secret],
          redirect_uri: SLACK_CONFIG[:slack_redirect_uri],
          code: params[:code]
        }
      )

      team_id = response['team_id']
      $teams[team_id] = {
        user_access_token: response['access_token'],
        bot_user_id: response['bot']['bot_user_id'],
        bot_access_token: response['bot']['bot_access_token']
      }

      auth_info = AuthInfo.new(
        :bot_token => response['access_token'],
        :bot_id => response['bot']['bot_user_id'],
        :user_token => response['bot']['bot_access_token']
      )
      auth_info.save

      $teams[team_id]['client'] = create_slack_client(response['bot']['bot_access_token'])
      status 200
      body "<img src='https://cdn1.tnwcdn.com/wp-content/blogs.dir/1/files/2016/03/changed-passwords-to-incorrect_admin052413y4ihq.jpg'>"
    rescue Slack::Web::Api::Error => e
      status 403
      body "Auth failed! Reason: #{e.message}<br/>#{add_to_slack_button}"
    end
  end
end
