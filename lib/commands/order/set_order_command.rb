require 'models/order'
require 'date'
require 'days'

class SetOrderCommand
  def prepare(data)
    request = data[:user_message]
    @lunch = format_lunch(request)
    @user_id = data[:user_id]
    @user_name = data[:user_name]
    @user_email = data[:user_email]
    @date = data[:date] || Date.today
  end

  def run

    create_user if !user_exist?
    update_user if user_exist? && !user_dont_have_email?

    order = Order.last(
      :user_id => @user_id,
      :date => (Days.from_monday_to_friday)
    )

    if @lunch.empty?
      "That is not a valid order."
    else
      place_order(order)
    end
  end

  def applies_to(request)
    request.start_with?("order:")
  end

  private

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

  def user_exist?
    Crafter.last(:slack_id => @user_id)
  end

  def user_dont_have_email?
    crafter = Crafter.last(:slack_id => @user_id)
    crafter.email
  end

  def format_lunch(request)
    order = request.gsub("order:", "")
    if order[0] == " "
      order[0] = ""
    end
    order
  end

  def place_order(order)
    if order
      update(order)
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
