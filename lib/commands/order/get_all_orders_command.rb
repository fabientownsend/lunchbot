require 'models/order'
require 'models/crafter'
require 'days'

module Commands
  class GetAllOrders
    def run
      format_response(orders)
    end

    def applies_to(request)
      request = request[:user_message].downcase
      request == "all orders?"
    end

    def prepare(data)
    end

    private

    def orders
      orders_of_the_week = Order.all(:date => Days.from_monday_to_friday)

      orders_of_the_week.map do |order|
        "#{full_name(order)}: #{order.lunch}" unless order.lunch.nil?
      end.compact.sort
    end

    def full_name(order)
      if guest?(order)
        order.user_name
      else
        Crafter.first(:slack_id => order.user_id).user_name
      end
    end

    def guest?(order)
      !order.user_id
    end

    def format_response(orders)
      return "no orders" if orders.empty?
      orders.join("\n").strip
    end
  end
end
