require_relative 'menu' #TODO add bootstrap file

class EventHandler
  def EventHandler
    Menu.new
  end

  def self.message(team_id, event_data)
    user_id = event_data['user']

    unless user_id == $teams[team_id][:bot_user_id]
      self.send_response(team_id, user_id)
    end
  end

  def self.send_response(team_id, user_id, channel = user_id, ts = nil)
    $teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "Here is the menu #{Menu.url}"
        )
  end
end
