require 'models/order'

class SetOrderCommand
  def prepare(data)
    request = data[:user_message]
    @lunch = request.gsub("order me: ", "")
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end

  def run()
    order = Order.last(:user_id => @user_id)

    if order
      update(order)
    else
      place_new_order
    end

    "Your order `#{Order.first(:user_id => @user_id).lunch}` is updated"
  end

  def applies_to(request)
    request.start_with?("order me: ") && request.split.size > 2
  end

  private

  def update(order)
    order.lunch = @lunch
    order.save
  end

  def place_new_order
    order = Order.new(
      :user_name => @user_name,
      :user_id => @user_id,
      :lunch => @lunch,
      :date => Time.now
    )
    order.save
  end
end
