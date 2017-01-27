class PlaceOrderGuest
  def initialize(lunch_order, name, host_id)
    @lunch_order = lunch_order
    @name = name
    @host_id = host_id
  end

  def run
    lunch_order = Order.last(:user_name => @name)

    if lunch_order
      lunch_order.lunch = @lunch_order
      lunch_order.save
    else
      new_order = Order.new(
      :user_name => @name,
      :lunch => @lunch_order,
      :date => Time.now,
      :host => @host_id
      )
      new_order.save
    end
  end
end
