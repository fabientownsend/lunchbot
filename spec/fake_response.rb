class FakeResponse
  attr_reader :message
  attr_reader :team_id
  attr_reader :user_id

  def send(message, team_id, user_id)
    @message = message
    @team_id = team_id
    @user_id = user_id
  end
end
