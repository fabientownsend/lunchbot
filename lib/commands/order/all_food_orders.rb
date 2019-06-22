# typed: true
require 'models/order'
require 'days'

module Commands
  class AllFoodOrders
    def self.description
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      "all food orders" == request
    end

    def prepare(data)
      @requester = User.profile(data[:user_id])
    end

    def run
      counted_orders.map do |order, count|
        render_orders_count(order, count)
      end.join.strip
    end

    private

    attr_reader :requester

    def counted_orders
      orders.each_with_object(Hash.new(0)) do |order, results|
        results[order.lunch] += 1
      end
    end

    def orders
      Order.placed_in(requester.office)
    end

    def render_orders_count(order, count)
      "#{order}: #{count}\n" unless order.nil?
    end
  end
end
