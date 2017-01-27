require 'get_all_orders_command'
require 'set_order_command'

RSpec.describe GetAllOrdersCommand do
  it "returns no orders" do
    get_all_orders_command = GetAllOrdersCommand.new

    expect(get_all_orders_command.run).to eq("no orders")
  end

  it "returns all orders when its returned" do
    get_all_orders_command = GetAllOrdersCommand.new

    message = "burger"
    event_data = {user_id: "asdf", user_name: "Will" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    response = get_all_orders_command.run()
    list_all_orders = "Will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return all order with a new line for each orders" do
    get_all_orders_command = GetAllOrdersCommand.new

    message = "burger"
    event_data = {user_id: "asdf", user_name: "Will" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    message = "fish"
    event_data = {user_id: "qwer", user_name: "Fabien" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    response = get_all_orders_command.run()
    list_all_orders = "Will: burger\nFabien: fish"
    expect(response).to eq(list_all_orders)
  end
end
