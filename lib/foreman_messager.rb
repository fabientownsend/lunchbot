require 'response'

class ForemanMessager
  def initialize
    @slack_responder = Response.new
  end

  def update_team_id(team_id)
    @team_id = team_id
  end

  def send(message)
    @slack_responder.send(message, @team_id, foreman_id)
  end

  private

  def foreman_id
    Apprentice.first.slack_id
  end
end
