require_relative 'menu'
require_relative 'response'
require_relative 'request_parser'
require_relative 'order_list'
require_relative 'order'
require_relative 'apprentice_rota'

class MessageHandler
  def initialize()
    @menu = Menu.new
    @order_list = OrderList.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
    @request_parser = RequestParser.new
  end
  
  def handle(team_id, event_data) 
    user_id = event_data['user']
    channel = event_data['channel']
    user_message = event_data['text']

    returned_command = @request_parser.parse(event_data)
    returned_command.run()

    if returned_command.response?
      respond(returned_command.response, team_id, user_id, channel)
    end

    if user_request == "foreman"
      bot_answer = "The foreman for this week is #{@apprentice_rota.foremanName()}"
      respondToMessage(bot_answer, team_id, user_id, channel)
    else
      respondToMessage("This isn't a valid request", team_id, user_id)
    end
  end

  def respond(bot_answer, team_id, user_id, channel = user_id)
      response = Response.new(team_id, channel)
      response.send(bot_answer)
  end

  private
  
  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end
end
