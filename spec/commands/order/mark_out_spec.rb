require 'commands/order/mark_out'
require 'models/order'
require 'days'

RSpec.describe MarkOut do
  it "should place an out order when command is run" do
    out = MarkOut.new
    out.prepare(user_id: "id", user_name: "Will")
    out.run

    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end

  it "should update existing orders" do
    Helper.order(
      user_id: "id",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )

    out = MarkOut.new
    out.prepare(user_id: "id", user_name: "Will")
    out.run

    expect(Order.count).to eq(1)
    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end

  it "update the current week" do
    Helper.order_previous_monday(
      user_id: "id",
      user_name: "will",
      user_message: "burger"
    )

    out = MarkOut.new
    out.prepare(user_id: "id", user_name: "Will")
    out.run

    expect(Order.first.lunch).to eq("burger")
    expect(Order.last.lunch).to eq("out")
  end
end
