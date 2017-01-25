require 'order'

class GetOrderCommand
  attr_reader :response

  def initialize(message, order_list)
    @user_message = message
    @order_list = order_list
  end

  def response?
    response
  end

  def run()
    user_message = @user_message.gsub("order: ", "")
    user_id_meal_researched = user_message[/(?<=\<@)(\w+)(?=>)/]

    the_order = Order.last(:user_id => user_id_meal_researched).lunch
    @response = "<@#{user_id_meal_researched}> ordered: `#{the_order}`"
  end
end
