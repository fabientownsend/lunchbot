require 'commands/get_all_orders_command'
require 'commands/set_order_command'

RSpec.describe GetAllOrdersCommand do
  let (:get_all_orders_command) { GetAllOrdersCommand.new }
  it "returns no orders" do
    expect(get_all_orders_command.run).to eq("no orders")
  end

  it "returns all orders when its returned" do
    order("asdf", "Will", "burger")

    response = get_all_orders_command.run()
    list_all_orders = "Will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return all order with a new line for each orders" do
    order("qwer", "Fabien", "fish")
    order("asdf", "Will", "burger")

    response = get_all_orders_command.run()
    list_all_orders = "Fabien: fish\nWill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "the order are returned sorted by name" do
    order("asdf", "Will", "burger")
    order("qwer", "Fabien", "fish")

    response = get_all_orders_command.run()
    list_all_orders = "Fabien: fish\nWill: burger"
    expect(response).to eq(list_all_orders)
  end

  private

  def order(user_id, name, meal)
    event_data = {user_id: user_id, user_name: name, user_message: meal}
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data)
    set_order_command.run
  end
end
