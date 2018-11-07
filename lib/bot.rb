class Bot

  def initialize(client: nil)
    @client = client || Slack::Web::Client.new
  end

  def send(message, user_id)
    Logger.info("BOT RESPONSE: #{message}, to: #{user_id}")

    client.chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  end

  private

  attr_reader :client
end
