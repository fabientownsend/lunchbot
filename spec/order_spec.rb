require_relative '../lib/order'
require_relative '../lib/order_list'

RSpec.describe Order do
  it "stores users lunch order" do
    order = Order.new("Will", "food", "id")
    expect(order.lunch_order).to eq("food")
    expect(order.user_name).to eq("Will")
    expect(order.user_id).to eq("id")
  end
end

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
