require 'models/order'

class GetOrderCommand
  def prepare(data)
    @user_message = data[:user_message]
  end

  def run()
    user_message = @user_message.gsub("order: ", "")
    user_id_meal_researched = user_message[/(?<=\<@)(\w+)(?=>)/]

    the_order = Order.last(:user_id => user_id_meal_researched).lunch
    if the_order
      "<@#{user_id_meal_researched}> ordered: `#{the_order}`"
    else
      "That person does not have an order!"
    end
  end

  def applies_to(request)
    request.start_with?("order:") && request.split.size > 1
  end
end
