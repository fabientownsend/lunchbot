require 'models/order'
require 'days'

module Commands
  class AllFoodOrders
    def applies_to?(request)
      request = request[:user_message].downcase
      "all food orders" == request
    end

    def prepare(data)
      @user = User.profile(data[:user_id])
    end

    def run
      counted_lunch = Order.placed_in(@user.office).each_with_object(Hash.new(0)) do |obj, hash|
        hash[obj.lunch] += 1
      end

      counted_lunch.map { |lunch, total| format_text(lunch, total) }.join.strip
    end

    def format_text(lunch, total)
      "#{lunch}: #{total}\n" unless lunch.nil?
    end
  end
end
