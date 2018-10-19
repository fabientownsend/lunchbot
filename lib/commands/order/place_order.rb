require 'models/order'
require 'date'
require 'days'

module Commands
  class PlaceOrder
    def applies_to?(request)
      request = request[:user_message].downcase
      request.start_with?("order:")
    end

    def prepare(data)
      @lunch = format_lunch(data[:user_message])
      @user_id = data[:user_id]
      @user_name = data[:user_name]
      @user_email = data[:user_email]
      @date = data[:date] || Date.today

      Crafter.create(data) unless Crafter.profile(data[:user_id])
    end

    def run
      if user_dont_have_email?
        update_user
      end

      return "That is not a valid order." if @lunch.empty?

      if !Crafter.has_office?(@user_id)
        return "You need to add your office. ex: \"office: london\""
      end

      place_order
    end

    private

    def update_user
      user = Crafter.last(:slack_id => @user_id)
      user.email = @user_email
      user.save
    end

    def user_dont_have_email?
      crafter = Crafter.profile(@user_id)
      !crafter.email
    end

    def format_lunch(request)
      order = request.gsub("order:", "")
      order[0] = "" if order[0] == " "
      order
    end

    def place_order
      order_places = Order.last(
        :user_id => @user_id,
        :date => Days.from_monday_to_friday
      )

      if order_places
        update(order_places)
      else
        place_new_order
      end
    end

    def update(order)
      order.lunch = @lunch
      order.save
      "#{@user_name} updated their order to`#{@lunch}`."
    end

    def place_new_order
      order = Order.new(
        :user_name => @user_name,
        :user_id => @user_id,
        :lunch => @lunch,
        :date => @date
      )
      order.save
      "#{@user_name} just ordered `#{@lunch}`."
    end
  end
end
