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

  def find_lunch(user_id)
    @orders[user_id].lunch
  end
end
