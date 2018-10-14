require_relative 'models/auth_info'

class Response
  def setup
    token = AuthInfo.last.bot_token if AuthInfo.last
    raise "No token!" unless token
    Slack.configure do |config|
      config.token = token
    end
    @slack_client = Slack::Web::Client.new
  end

  def send(message, user_id)
    @slack_client.chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  end
end
