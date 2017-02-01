require 'commands/order/place_order_guest'

RSpec.describe PlaceOrderGuest do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will", user_message: "order -james smith-: burger" } }

  it "save the order of a guest" do
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare(event_data_from_will)
    place_order_guest.run

     expect(Order.count).to eq(1)
  end

  it "updates guest order when new order is placed for same guest" do
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare(event_data_from_will)
    place_order_guest.run

    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare({user_id: "asdf", user_name: "Will", user_message: "order -james smith-: fish" })
    place_order_guest.run

    expect(Order.count).to eq(1)
    expect(Order.first.lunch).to eq("fish")
  end

  it "add another order when the name is different" do
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare(event_data_from_will)
    place_order_guest.run

    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare({user_id: "asdf", user_name: "Will", user_message: "order -smith james-: fish" })
    place_order_guest.run

    expect(Order.count).to eq(2)
    expect(Order.last.lunch).to eq("fish")
    expect(Order.last.user_name).to eq("smith james")
  end
end

