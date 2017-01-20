class Response
  def send(message, team_id, user_id)
    $teams[team_id]['client'].chat_postMessage(
      as_user: 'true',
      channel: user_id,
      text: message
    )
  end
end
