require 'models/order'
require 'days'

class AllFoodOrders
  def applies_to(request)
    "all food orders" == request
  end

  def prepare(data)
  end

  def run
    total_each_meal = Order.aggregate(
      :lunch,
      :all.count,
      :date => (Days.from_monday_to_friday))

    format_list(total_each_meal)
  end

  def format_list(total_each_meal)
    total_each_meal.map { |lunch, total| "#{lunch}: #{total}\n" }.join.strip
  end
end
