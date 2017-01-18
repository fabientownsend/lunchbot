require_relative '../lib/order_list'

RSpec.describe OrderList do
  it "adding order updates orders list" do
    order_list = OrderList.new()
    order = Order.new("Will", "food", "id")
    order_list.add_order(order)
    expect(order_list.orders["id"]).to eq(order)
  end

  it "removing order updates orders list" do
    order_list = OrderList.new()
    order = Order.new("Will", "food", "id")
    order_list.add_order(order)
    order_list.remove_order("id")
    expect(order_list.orders["id"]).to eq(nil)
  end

  it "remplace the previous order when you use the same id" do
    order_list = OrderList.new()
    order_list.add_order(Order.new("Will", "food", "id1"))
    order_list.add_order(Order.new("Fabien", "food", "id1"))

    expect(order_list.orders.count).to eq(1)
  end

  it "add a new order" do
    order_list = OrderList.new()
    order_list.add_order(Order.new("Will", "food", "id1"))
    order_list.add_order(Order.new("Fabien", "food", "id2"))

    expect(order_list.orders.count).to eq(2)
  end
end
