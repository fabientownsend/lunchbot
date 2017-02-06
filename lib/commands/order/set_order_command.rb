require 'models/order'
require 'date'

class SetOrderCommand
  def prepare(data)
    request = data[:user_message]
    @lunch = format_lunch(request)
    @user_id = data[:user_id]
    @user_name = data[:user_name]
    @date = data[:date] || Date.today
  end

  def run
    order = Order.last(:user_id => @user_id)

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
