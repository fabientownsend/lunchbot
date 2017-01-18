require_relative 'menu'
require_relative 'response'

class MessageHandler
  def initialize()
    @menu = Menu.new
  end
  
  def handle(team_id, event_data)
    user_id = event_data['user']
    respondToMessage(team_id, user_id)
  end

  def respondToMessage(team_id, user_id)
      response = Response.new(team_id, user_id)
      response.send("Menu has been set.")
  end
end
