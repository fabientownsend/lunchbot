require_relative 'menu'
require_relative 'response'
require_relative 'request_parser'

class MessageHandler
  def initialize()
    @menu = Menu.new
    @request_parser = RequestParser.new
  end
  
  def handle(team_id, event_data)
    user_id = event_data['user']

    if @request_parser.parse(event_data['text']) == "menu"
      respondToMessage(team_id, user_id, event_data['channel'])
    else
      respondToMessage(team_id, user_id)
    end


  end

  def respondToMessage(team_id, user_id, channel = user_id)
      response = Response.new(team_id, channel)
      response.send("Menu has been set.")
  end
end
