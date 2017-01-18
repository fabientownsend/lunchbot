class MessageHandler
  def initialize()
    @menu = Menu.new
  end
  
  def handle(team_id, event_data)
    user_id = event_data['user']
    if !user_id == $teams[team_id][:bot_user_id]
      determineMessage(event_data)
    end
  end

  def determineMessage(data)
      if data["text"].include?("new menu")
        @menu.set_url(@menu.parse_url(data["text"]))
        response = Response.new(team_id, user_id)
        response.send("Menu has been set.")
      end
  end
end
