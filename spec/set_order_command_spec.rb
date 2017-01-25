require 'set_order_command'

RSpec.describe SetOrderCommand do
  it "reccord an order in the database" do
    message = "burger"
    event_data = {user_id: "asdf", user_name: "a name" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    expect(Order.count).to eq(1)
  end

  it "a user should have only one order" do
    message = "burger"
    event_data = {user_id: "asdf", user_name: "a name" }
    set_order_command = SetOrderCommand.new(message, event_data)

    set_order_command.run
    set_order_command.run

    expect(Order.count).to eq(1)
  end

  it "updates users pre existing order when they place another order" do
    message = "chilli"
    event_data = {user_id: "asdf", user_name: "a name" }
    set_order_command = SetOrderCommand.new(message, event_data)

    set_order_command.run

    message = "burger"
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    expect(Order.last(:user_id => "asdf").lunch).to eq("burger")
  end

  it "total of order is equal to two when get two different order" do
    message = "burger"
    event_data = {user_id: "asdf", user_name: "a name" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    event_data = {user_id: "qwery", user_name: "a name" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    expect(Order.count).to eq(2)
  end

  it "return the name of the first persn which ordered" do
    message = "burger"
    event_data = {user_id: "asdf", user_name: "Will" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    event_data = {user_id: "qwery", user_name: "Fabien" }
    set_order_command = SetOrderCommand.new(message, event_data)
    set_order_command.run

    expect(Order.first.user_name).to eq("Will")
  end
end
