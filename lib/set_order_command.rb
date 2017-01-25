require 'order'

class SetOrderCommand
  attr_reader :response

  def initialize(lunch, event_data)
    @lunch = lunch
    @user_id = event_data[:user_id]
    @user_name = event_data[:user_name]
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
