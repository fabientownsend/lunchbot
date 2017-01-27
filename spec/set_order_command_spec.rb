require 'set_order_command'

RSpec.describe SetOrderCommand do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will" } }
  let (:event_data_from_fabien) { {user_id: "qwert", user_name: "Fabien" } }

  it "reccord an order in the database" do
    message = "burger"
    set_order_command = SetOrderCommand.new(message, event_data_from_will)
    set_order_command.run

    expect(Order.count).to eq(1)
  end

  it "a user should have only one order" do
    message = "burger"
    set_order_command = SetOrderCommand.new(message, event_data_from_will)

    set_order_command.run
    set_order_command.run

    expect(Order.count).to eq(1)
  end

  it "updates users pre existing order when they place another order" do
    message = "chilli"
    set_order_command = SetOrderCommand.new(message, event_data_from_will)

    set_order_command.run

    message = "burger"
    set_order_command = SetOrderCommand.new(message, event_data_from_will)
    set_order_command.run

    expect(Order.last(:user_id => "asdf").lunch).to eq("burger")
  end

  it "total of order is equal to two when get two different order" do
    message = "burger"
    set_order_command = SetOrderCommand.new(message, event_data_from_will)
    set_order_command.run

    set_order_command = SetOrderCommand.new(message, event_data_from_fabien)
    set_order_command.run

    expect(Order.count).to eq(2)
  end

  it "return the name of the first persn which ordered" do
    message = "burger"
    set_order_command = SetOrderCommand.new(message, event_data_from_will)
    set_order_command.run

    set_order_command = SetOrderCommand.new(message, event_data_from_fabien)
    set_order_command.run

    expect(Order.first.user_name).to eq("Will")
  end
end
