require 'bot'

class ForemanMessager
  def initialize(bot)
    @bot = bot
  end

  def send(message)
    @bot.send(message, foreman_id)
  end

  private

  def foreman_id
    Apprentice.first.slack_id
  end
end
