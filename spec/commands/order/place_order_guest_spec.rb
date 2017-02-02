require 'commands/order/place_order_guest'
require 'models/order'

RSpec.describe PlaceOrderGuest do
  it "save the order of a guest" do
    Helper.order_guest({name: "james smith", meal: "burger", from: "slack id"})

    expect(Order.last(:user_name => "james smith")).not_to be(nil)
  end

  it "a guest has a host" do
    slack_id = "slack id"
    Helper.order_guest({name: "james smith", meal: "burger", from: slack_id})

    expect(Order.last(:user_name => "james smith").host).to eq(slack_id)
  end

  it "updates guest order when new order is placed for same guest" do
    Helper.order_guest({name: "james smith", meal: "burger", from: "slack id"})
    Helper.order_guest({name: "james smith", meal: "fish", from: "slack id"})

    expect(Order.last(:user_name => "james smith").lunch).to eq("fish")
  end

  it "add another order when the name is different" do
    Helper.order_guest({name: "james smith", meal: "burger", from: "slack id"})
    Helper.order_guest({name: "jean bon", meal: "fish", from: "slack id"})

    expect(Order.last(:user_name => "james smith").lunch).to eq("burger")
    expect(Order.last(:user_name => "jean bon").lunch).to eq("fish")
  end
end

