require 'commands/order/out'
require 'models/order'

RSpec.describe Out do
  it "should place an out order when command is run" do
    out = Out.new
    out.prepare({user_id: "id", user_name: "Will"})
    out.run

    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end

  it "should update existing orders" do
    order = Order.new(
      :user_name => "Will",
      :user_id => "id",
      :lunch => "fish",
      :date => Time.now
    )
    order.save

    out = Out.new
    out.prepare({user_id: "id", user_name: "Will"})
    out.run

    expect(Order.count).to eq(1)
    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end
end
