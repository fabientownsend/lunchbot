# typed: true
require 'models/order'
require 'date'
require 'days'

module Commands
  class CopyOrder
    def self.description
      "Copy someone's order | `copy order: [@slack_username]`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.start_with?("copy order:")
    end

    def prepare(data)
      @user_id = data[:user_id]
      @user_name = data[:user_name]
      request = data[:user_message]
      find_user_to_copy = request.gsub("copy order: ", "")
      @user_to_copy = find_user_to_copy[/(?<=\<@)(\w+)(?=>)/]
    end

    def run
      order_to_copy = Order.last(
        :user_id => @user_to_copy,
        :date => Days.from_monday_to_friday
      )

      if order_to_copy
        place_order(order_to_copy.lunch)
        "#{@user_name} just copied <@#{@user_to_copy}>'s order!"
      else
        "That user does not have an order!"
      end
    end

    private

    def place_order(copied_lunch)
      existing_order = Order.last(
        :user_id => @user_id,
        :date => Days.from_monday_to_friday
      )

      if existing_order
        update(existing_order, copied_lunch)
      else
        place_new_order(copied_lunch)
      end
    end

    def update(order, lunch)
      order.lunch = lunch
      order.save
    end

    def place_new_order(lunch)
      order = Order.new(
        :user_id => @user_id,
        :user_name => @user_name,
        :lunch => lunch,
        :date => Date.today
      )
      order.save
    end
  end
end
