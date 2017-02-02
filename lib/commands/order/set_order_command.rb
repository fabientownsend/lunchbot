require 'models/order'

class SetOrderCommand
  def prepare(data)
    request = data[:user_message]
    @lunch = request.gsub("order: ", "")
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end

  def run()
    order = Order.last(:user_id => @user_id)

    if @lunch
      place_order(order)
    else
      "That is not a valid order."
    end
  end

  def applies_to(request)
    request.start_with?("order:") 
  end

  private

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
      :date => Time.now
    )
    order.save
    "#{@user_name} just ordered `#{@lunch}`."
  end
end
