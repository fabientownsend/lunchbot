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
end
