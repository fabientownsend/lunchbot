require 'models/order'
require 'days'

module Commands
  class AllFoodOrders
    def applies_to?(request)
      request = request[:user_message].downcase
      "all food orders" == request
    end

    def prepare(data)
      @crafter = User.profile(data[:user_id])
    end

    def run
      bla = Order.placed_in(@crafter.office).each_with_object(Hash.new(0)) do |obj, h|
        h[obj.lunch] += 1
      end

      bla.map { |lunch, total| format_text(lunch, total) }.join.strip
    end

    def format_text(lunch, total)
      "#{lunch}: #{total}\n" unless lunch.nil?
    end
  end
end
