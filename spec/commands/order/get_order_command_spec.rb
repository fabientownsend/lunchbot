require 'commands/order/get_order_command'

RSpec.describe GetOrderCommand do
  let (:fake_data) {{user_name: "Will", user_id: "w_id", user_message: "order? <@f_id>"}}

  it "returns the user specified order" do
    order = Order.new(
      :user_name => "Fabien",
      :user_id => "f_id",
      :lunch => "fish",
      :date => Time.now
    )
    order.save
    get_order = GetOrderCommand.new
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("<@f_id> ordered: `fish`.")
  end

  it "lets user know if the user id give in invalid" do
    get_order = GetOrderCommand.new
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("That person does not have an order!")
  end
end
