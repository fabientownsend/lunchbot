require 'order'

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
      order.lunch = @lunch
      order.save
    else
      order = Order.new(
        :user_name => @user_name,
        :user_id => @user_id,
        :lunch => @lunch,
        :date => Time.now
      )
      order.save
    end

    "Your order `#{order.lunch}` is updated"
  end

  def applies_to(request)
    request.start_with?("order me: ") && request.split.size > 2
  end
end
