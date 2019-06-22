# typed: true
class Bot
  def initialize
    @client = Slack::Web::Client.new
  end

  def send(message, user_id)
    Logger.info("BOT RESPONSE: #{message}, to: #{user_id}")

    begin
      client.chat_postMessage(
        as_user: 'true',
        channel: user_id,
        text: message
      )
    rescue StandardError => error
      Logger.alert(error)
    end
  end

  private

  attr_reader :client
end
