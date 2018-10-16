require 'days'
require 'feature_flag'
require 'models/crafter'
require 'models/order'
require 'tiny_logger'

module Commands
  class GetAllOrders < FeatureFlag
    release_for 'Fabien Townsend'

    def applies_to(request)
      request = request[:user_message].downcase
      request == "all orders?"
    end

    def prepare(data)
      @crafter_name = data[:user_name]
      @crafter = data[:user_id]
    end

    def run
      format_response(orders)
    end

    private

    def orders
      orders_of_the_week = []

      if feature_access?(@crafter_name)
        Logger.info("USE NEW FEATURE ORDER FILTERED")
        orders_of_the_week = Order.all(:date => Days.from_monday_to_friday).select do |order|
          Crafter.profile(order.user_id).office == @crafter.office
        end
        return orders_of_the_week if orders_of_the_week.empty?
      else
        Logger.info("USE OLD FEATURE ORDER FILTERED")
        orders_of_the_week = Order.all(:date => Days.from_monday_to_friday)
      end

      orders_of_the_week.map do |order|
        name = full_name(order)
        unless order.lunch.nil? || name.nil?
          "#{name}: #{order.lunch}"
        end
      end.compact.sort
    end

    def full_name(order)
      if guest?(order)
        order.user_name
      else
        Crafter.profile(order.user_id).user_name if Crafter.profile(order.user_id)
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
