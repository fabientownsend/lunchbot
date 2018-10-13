require 'models/order'
require 'date'
require 'days'
require 'feature_flag'

module Commands
  class PlaceOrder < FeatureFlag
    release_for 'Fabien Townsend'

    def applies_to(request)
      request = request[:user_message].downcase
      request.start_with?("order:")
    end

    def prepare(data)
      @lunch = format_lunch(data[:user_message])
      @user_id = data[:user_id]
      @user_name = data[:user_name]
      @user_email = data[:user_email]
      @date = data[:date] || Date.today
    end

    def run
      create_user unless user_exists?

      if user_exists? && user_dont_have_email?
        update_user
      end

      return "That is not a valid order." if @lunch.empty?

      if feature_access?(@user_name) && user_do_not_have_office?
        return "You need to add your office. ex: \"office: london\""
      end

      place_order
    end

    private

    def user_do_not_have_office?
      crafter = Crafter.last(:slack_id => @user_id)
      !crafter.office
    end

    def create_user
      new_user = Crafter.new(
        :user_name => @user_name,
        :slack_id => @user_id,
        :email => @user_email
      )
      new_user.save
    end

    def update_user
      user = Crafter.last(:slack_id => @user_id)
      user.email = @user_email
      user.save
    end

    def user_exists?
      Crafter.last(:slack_id => @user_id)
    end

    def user_dont_have_email?
      crafter = Crafter.last(:slack_id => @user_id)
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
