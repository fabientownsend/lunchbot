require 'commands/get_all_orders_command'
require 'commands/set_order_command'

RSpec.describe GetAllOrdersCommand do
  it "returns no orders" do
    get_all_orders_command = GetAllOrdersCommand.new

    expect(get_all_orders_command.run).to eq("no orders")
  end

  it "returns all orders when its returned" do
    get_all_orders_command = GetAllOrdersCommand.new

    event_data = {user_id: "asdf", user_name: "Will", user_message: "burger"}
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data)
    set_order_command.run

    response = get_all_orders_command.run()
    list_all_orders = "Will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return all order with a new line for each orders" do
    get_all_orders_command = GetAllOrdersCommand.new

    event_data = {user_id: "asdf", user_name: "Will", user_message: "burger"}
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data)
    set_order_command.run

    event_data = {user_id: "qwer", user_name: "Fabien", user_message: "fish"}
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data)
    set_order_command.run

    response = get_all_orders_command.run()
    list_all_orders = "Will: burger\nFabien: fish"
    expect(response).to eq(list_all_orders)
  end
end
