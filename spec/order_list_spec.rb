require 'order_list'

RSpec.describe OrderList do
  let (:order_list) { OrderList.new }

  it "adding order updates orders list" do
    order = Order.new("Will", "food", "id")
    order_list.add_order(order)
    expect(order_list.orders["id"]).to eq(order)
  end

  it "removing order updates orders list" do
    order = Order.new("Will", "food", "id")
    order_list.add_order(order)
    order_list.remove_order("id")
    expect(order_list.orders["id"]).to eq(nil)
  end

  it "remplace the previous order when you use the same id" do
    order_list.add_order(Order.new("Will", "food", "id1"))
    order_list.add_order(Order.new("Fabien", "food", "id1"))

    expect(order_list.orders.count).to eq(1)
  end

  it "add a new order" do
    order_list.add_order(Order.new("Will", "food", "id1"))
    order_list.add_order(Order.new("Fabien", "food", "id2"))

    expect(order_list.orders.count).to eq(2)
  end

  it "find a meal from an id" do
    order_list.add_order(Order.new("Will", "burger", "id1"))
    order_list.add_order(Order.new("Fabien", "fish and chips", "id2"))

    expect(order_list.find_lunch("id2")).to eq("fish and chips")
    expect(order_list.find_lunch("id1")).to eq("burger")
  end
end
