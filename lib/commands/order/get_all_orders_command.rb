require 'models/order'
require 'days'

class GetAllOrders
  def run
    format_response(orders)
  end

  def applies_to(request)
    request == "all orders?"
  end

  def prepare(data)
  end

  private

  def orders
    orders_of_the_week = Order.all(:date => (Days.from_monday_to_friday))

    orders_of_the_week.map { |order|
      "#{order.user_name}: #{order.lunch}" if !order.lunch.nil?
    }.compact.sort
  end

  def format_response(orders)
    response = ""
    if orders.empty?
      response = "no orders"
    else
      response = orders.join("\n").strip
    end

    response
  end
end
