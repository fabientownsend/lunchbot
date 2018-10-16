require_relative 'models/auth_info'

class Response
  def setup
    token = ENV['SLACK_API_TOKEN']
    raise "No token!" unless token
    Slack.configure do |config|
      config.token = token
    end
    @slack_client = Slack::Web::Client.new
  end

  def send(message, user_id)
    Logger.info("BOT RESPONSE: #{message}, to: #{user_id}")
    return if message.nil?
    @slack_client.chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  rescue StandardError => error
    Logger.alert(error)
  end
end
