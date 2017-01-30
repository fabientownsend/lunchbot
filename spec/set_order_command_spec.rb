require 'set_order_command'

RSpec.describe SetOrderCommand do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will", user_message: "fish" } }
  let (:event_data_from_fabien) { {user_id: "qwert", user_name: "Fabien", user_message: "burger" } }

  it "reccord an order in the database" do
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)
    set_order_command.run

    expect(Order.count).to eq(1)
  end

  it "a user should have only one order" do
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)

    set_order_command.run
    set_order_command.run

    expect(Order.count).to eq(1)
  end

  it "updates users pre existing order when they place another order" do
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)
    set_order_command.run

    set_order_command = SetOrderCommand.new
    set_order_command.prepare({user_id: "asdf", user_name: "Will", user_message: "burger"})
    set_order_command.run

    expect(Order.last(:user_id => "asdf").lunch).to eq("burger")
  end

  it "total of order is equal to two when get two different order" do
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)
    set_order_command.run

    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_fabien)
    set_order_command.run

    expect(Order.count).to eq(2)
  end

  it "return the name of the first persn which ordered" do
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)
    set_order_command.run

    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_fabien)
    set_order_command.run

    expect(Order.first.user_name).to eq("Will")
  end
end
