require 'bot'

class ForemanMessager
  def initialize(bot)
    @bot = bot
  end

  def update_team_id(team_id)
    @team_id = team_id
  end

  def send(message)
    @bot.send(message, @team_id, foreman_id)
  end

  private

  def foreman_id
    Apprentice.first.slack_id
  end
end
