class MessageHandler
  attr_reader :menu_url

  def self.handle(team_id, event_data)
    user_id = event_data['user']
    @menu_url = /((http|https):\/{2})+([A-Za-z]+\.)+(com|co.uk)/.match(event_data['message'])

    unless user_id == $teams[team_id][:bot_user_id]
      self.send_response(team_id, user_id)
    end
  end

  def self.send_response(team_id, user_id, channel = user_id, ts = nil)
    $teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "Hello #{@menu_url}"
        )
  end
end
