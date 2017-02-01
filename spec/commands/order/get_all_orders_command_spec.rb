require 'commands/order/get_all_orders_command'
require 'spec_helper'

RSpec.describe GetAllOrdersCommand do
  let (:get_all_orders_command) { GetAllOrdersCommand.new }
  it "returns no orders" do
    expect(get_all_orders_command.run).to eq("no orders")
  end

  it "returns all orders when its returned" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})

    response = get_all_orders_command.run()
    list_all_orders = "will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return all order with a new line for each orders" do
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "fish"})
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})

    response = get_all_orders_command.run()
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "the order are returned sorted by name" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "fish"})

    response = get_all_orders_command.run()
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end
end
