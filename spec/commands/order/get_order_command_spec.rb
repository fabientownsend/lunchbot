require 'commands/order/get_order'
require 'days'

RSpec.describe Commands::GetOrder do
  let(:get_order) { Commands::GetOrder.new }
  let(:fake_data) do
    {
      user_name: "Will",
      user_id: "w_id",
      user_message: "order? <@f_id>",
    }
  end

  it "returns the user specified order" do
    Helper.order(
      user_id: "f_id",
      user_name: "Fabien",
      user_message: "fish",
      date: Days.monday
    )
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("<@f_id> ordered: `fish`.")
  end

  it "lets user know if the user id give in invalid" do
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("That person does not have an order!")
  end

  it "return no order if the user don't have an order for the current week" do
    Helper.order_previous_monday(
      user_id: "f_id",
      user_name: "Fabien",
      user_message: "fish"
    )
    get_order.prepare(fake_data)

    expect(get_order.run).to eq("That person does not have an order!")
  end
end
