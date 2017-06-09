require 'models/order'
require 'days'

module Commands
  class GetOrder
    def prepare(data)
      @user_message = data[:user_message]
    end

    def run
      user_message = @user_message.gsub("order? ", "")
      user_id_meal_researched = user_message[/(?<=\<@)(\w+)(?=>)/]

      the_order = Order.last(
        :user_id => user_id_meal_researched,
        :date => Days.from_monday_to_friday
      )

      if the_order
        "<@#{user_id_meal_researched}> ordered: `#{the_order.lunch}`."
      else
        "That person does not have an order!"
      end
    end

    def applies_to(request)
      request.start_with?("order?")
    end
  end
end
