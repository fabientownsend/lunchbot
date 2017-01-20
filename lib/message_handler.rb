require_relative 'menu'
require_relative 'response'
require_relative 'request_parser'
require_relative 'order_list'
require_relative 'order'

class MessageHandler
  def initialize()
    @menu = Menu.new
    @order_list = OrderList.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
    @request_parser = RequestParser.new
  end
  
  def handle(team_id, event_data) #TODO: refactor with polymorphism
    user_id = event_data['user']
    channel = event_data['channel']
    user_message = event_data['text']

    user_request = @request_parser.parse(user_message)

    if user_request == "menu"
      save_menu_url(user_message)
      bot_answer = "<!here> Menu has been set: #{@menu.url}"
      respondToMessage(bot_answer, team_id, user_id, channel)
    elsif user_request == "get_menu"
      bot_answer = "This week the menu is from: #{@menu.url}"
      respondToMessage(bot_answer, team_id, user_id, channel)
    elsif user_request == "set_order"
      user_name = event_data['user_name']
      lunch = user_message.gsub("order me: ", "")
      puts user_id
      order = Order.new(user_name, lunch, user_id)
      @order_list.add_order(order)
      bot_answer = "Your order `#{order.lunch}` is updated"
      respondToMessage(bot_answer, team_id, user_id)
    elsif user_request == "get_order"
      user_message = user_message.gsub("order: ", "")
      user_id_meal_researched = user_message[/(?<=\<@)(\w+)(?=>)/]
      meal = @order_list.find_lunch(user_id_meal_researched)
      bot_answer = "<@#{user_id_meal_researched}> ordered: `#{meal}`"
      respondToMessage(bot_answer, team_id, user_id, channel)
    elsif user_request == "foreman"
      bot_answer = "The foreman for this week is #{@apprentice_rota.foreman().at(1)}"
      respondToMessage(bot_answer, team_id, user_id, channel)
    else
      respondToMessage("This isn't a valid request", team_id, user_id)
    end
  end

  def respondToMessage(bot_answer, team_id, user_id, channel = user_id)
      response = Response.new(team_id, channel)
      response.send(bot_answer)
  end

  private
  
  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end
end
