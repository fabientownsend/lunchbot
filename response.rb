class Response
  def initialize(team_id, user_id)
    @team_id = team_id
    @user_id = user_id
  end

  def send(message)
    $teams[team_id]['client'].chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  end
end
