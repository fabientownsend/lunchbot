require 'order'

class SetOrderCommand
  attr_reader :response

  def initialize(message, order_list, event_data)
    @user_message = message
    @order_list = order_list
    @user_id = event_data[:user_id]
    @user_name = event_data[:user_name]
  end

  def response?
    response
  end

  def run()
    lunch = @user_message.gsub("order me: ", "")

    order = Order.new
    order.attributes = {
      :user_name => @user_name,
      :user_id => @user_id,
      :lunch => lunch,
      :date => Time.now
    }
    order.save

    @response = "Your order `#{order.lunch}` is updated"
  end
end
