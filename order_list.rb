class OrderList
  attr_reader :orders

  def initialize()
    @orders = {}
  end
  
  def add_order(order)
    @orders[order.user_id] = order
  end

  def remove_order(user_id)
    @orders.delete(user_id)
  end
end
