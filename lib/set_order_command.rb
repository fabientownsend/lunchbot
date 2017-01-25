require 'order'

class SetOrderCommand
  attr_reader :response

  def initialize(lunch, data)
    @lunch = lunch
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end

  def response?
    response
  end

  def run()
    order = Order.last(:user_id => @user_id)

    if order
      order.lunch = @lunch
      order.save
    else
      order = Order.new
      order.attributes = {
        :user_name => @user_name,
        :user_id => @user_id,
        :lunch => @lunch,
        :date => Time.now
      }
      order.save
    end

    @response = "Your order `#{order.lunch}` is updated"
  end
end
