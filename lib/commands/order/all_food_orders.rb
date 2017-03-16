require 'models/order'
require 'days'

module Commands
  class AllFoodOrders
    def applies_to(request)
      "all food orders" == request
    end

    def prepare(data) end

    def run
      count_meal = Order.aggregate(
        :lunch,
        :all.count,
        date: Days.from_monday_to_friday
      )

      count_meal.map { |lunch, total|  format_text(lunch, total) }.join.strip
    end

    def format_text(lunch, total)
      "#{lunch}: #{total}\n" unless lunch.nil?
    end
  end
end
