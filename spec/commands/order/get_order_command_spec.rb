require 'commands/order/get_order_command'

RSpec.describe GetOrderCommand do
  let (:fake_data) { {
    user_name: "Will",
    user_id: "w_id",
    user_message: "order? <@f_id>"
  } }

  it "returns the user specified order" do
    Helper.order({
      user_id: "f_id",
      user_name: "Fabien",
      user_message: "fish",
      date: Days.monday
    })
    get_order = GetOrderCommand.new
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("<@f_id> ordered: `fish`.")
  end

  it "lets user know if the user id give in invalid" do
    get_order = GetOrderCommand.new
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("That person does not have an order!")
  end

  it "return not order when the user don't have an order for the current week" do
    Helper.order_previous_monday({
      user_id: "f_id",
      user_name: "Fabien",
      user_message: "fish",
    })
    get_order = GetOrderCommand.new
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("That person does not have an order!")
  end
end
