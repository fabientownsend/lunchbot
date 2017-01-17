class MessageHandler
  def self.handle(team_id, event_data, menu)
    @menu = menu
    user_id = event_data['user']

    unless user_id == $teams[team_id][:bot_user_id]
      self.send_response(team_id, user_id, event_data)
    end
  end

  def self.send_response(team_id, user_id, event_data, channel = user_id, ts = nil)

    if event_data["text"].include?("new menu")
      @menu.set_url(@menu.parse_url(event_data["text"]))
    end

    $teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "Here is the menu #{@menu.url}"
        )
  end
end
