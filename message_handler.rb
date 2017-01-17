require_relative 'menu'

class MessageHandler
  def initialize
    @menu = Menu.new
  end

  def handle(team_id, event_data)
    user_id = event_data['user']

    unless user_id == $teams[team_id][:bot_user_id]
      send_response(team_id, user_id, event_data)
    end
  end

  def send_response(team_id, user_id, event_data, channel = user_id)
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
