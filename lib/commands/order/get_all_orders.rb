require 'days'
require 'models/user'
require 'models/order'
require 'tiny_logger'

module Commands
  class GetAllOrders
    def self.description
      "See all orders | `orders?`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request == "orders?"
    end

    def prepare(data)
      @user_name = data[:user_name]
      @user_id = data[:user_id]
    end

    def run
      format_response(orders)
    end

    private

    def orders
      orders_of_the_week = []

      user = User.profile(@user_id)

      if user
        orders_of_the_week = Order.placed_in(user.office)
      end

      orders_of_the_week.map do |order|
        name = full_name(order)
        if !order.lunch.nil? && !name.nil?
          "#{name}: #{order.lunch}"
        end
      end.compact.sort
    end

    def full_name(order)
      if guest?(order)
        order.user_name
      else
        User.profile(order.user_id).user_name if User.profile(order.user_id)
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
