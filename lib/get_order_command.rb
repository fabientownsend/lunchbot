require 'order'

class GetOrderCommand
  def initialize(message)
    @user_message = message
  end

  def run()
    user_message = @user_message.gsub("order: ", "")
    user_id_meal_researched = user_message[/(?<=\<@)(\w+)(?=>)/]

    the_order = Order.last(:user_id => user_id_meal_researched).lunch
    "<@#{user_id_meal_researched}> ordered: `#{the_order}`"
  end
end
