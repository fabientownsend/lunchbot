require_relative 'models/auth_info'

class Response
  def setup
    token = AuthInfo.last.bot_token
    Slack.configure do |config|
      config.token = token 
    end
    @slack_client = Slack::Web::Client.new
  end

  def send(message, team_id, user_id)
    @slack_client.chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  end
end
