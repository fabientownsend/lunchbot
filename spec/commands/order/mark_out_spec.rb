require 'commands/order/mark_out'
require 'models/order'
require 'days'

RSpec.describe Commands::MarkOut do
  let(:out) { Commands::MarkOut.new }

  it "place an out order when command is run" do
    out.prepare(user_id: "id", user_name: "Will")
    out.run

    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end

  it "update existing orders" do
    Helper.order(
      user_id: "id",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )

    out.prepare(user_id: "id", user_name: "Will")
    out.run

    expect(Order.count).to eq(1)
    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end

  it "update the current week" do
    User.create(user_id: "id", user_name: "will", office: "london")
    Helper.order_previous_monday(
      user_id: "id",
      user_name: "will",
      user_message: "burger"
    )

    out.prepare(user_id: "id", user_name: "Will")
    out.run

    expect(Order.first.lunch).to eq("burger")
    expect(Order.last.lunch).to eq("out")
  end
end
