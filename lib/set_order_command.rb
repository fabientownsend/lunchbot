require 'order'

class SetOrderCommand
  def initialize(lunch, data)
    @lunch = lunch
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
end
