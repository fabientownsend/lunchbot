require 'models/order'
require 'date'
require 'days'

module Commands
  class PlaceOrder
    def self.description
      "Place an order | `order: [menu_item]`"
    end

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

      User.create(data) unless User.profile(data[:user_id])
    end

    def run
      if user_dont_have_email?
        update_user
      end

      return "That is not a valid order." if @lunch.empty?

      if !User.has_office?(@user_id)
        return "You need to add your office. ex: \"office: london\""
      end

      place_order
    end

    private

    def update_user
      user = User.last(:slack_id => @user_id)
      user.email = @user_email
      user.save
    end

    def user_dont_have_email?
      user = User.profile(@user_id)
      !user.email
    end

    def format_lunch(request)
      order = request.gsub("order:", "")
      order[0] = "" if order[0] == " "
      order
    end

    def place_order
      order_placed = Order.placed_for(@user_id)

      if order_placed
        order_placed.update_lunch(@lunch)
        "#{@user_name} updated their order to`#{@lunch}`."
      else
        place_new_order
        "#{@user_name} just ordered `#{@lunch}`."
      end
    end

    def place_new_order
      Order.place(
        :user_name => @user_name,
        :user_id => @user_id,
        :lunch => @lunch,
        :date => @date
      )
    end
  end
end
