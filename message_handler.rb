require_relative 'menu'

class MessageHandler
  def self.handle(team_id, event_data)
    user_id = event_data['user']
    @menu_url = /((http|https):\/{2})+([A-Za-z]+\.)+(com|co.uk)/.match(event_data['message'])

    unless user_id == $teams[team_id][:bot_user_id]
      self.send_response(team_id, user_id)
    end
  end

  def self.send_response(team_id, user_id, channel = user_id, ts = nil)
    menu = Menu.new
    $teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "Here is the menu #{menu.url}"
        )
  end
end
