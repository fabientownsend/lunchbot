require 'add_guest'

RSpec.describe AddGuest do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will" } }

  it "save a guest" do
    place_order_guest = AddGuest.new("james smith", "host id")
    response = place_order_guest.run

     expect(Order.count).to eq(1)
     expect(response).to eq("james smith added")
  end

  it "said if a guest already exist" do
    place_order_guest = AddGuest.new("james smith", "host id")
    place_order_guest.run
    place_order_guest = AddGuest.new("james smith", "host id")
    response = place_order_guest.run

    expect(Order.count).to eq(1)
     expect(response).to eq("james smith already exist")
  end

  it "add different guest" do
    place_order_guest = AddGuest.new("james smith", "host id")
    place_order_guest.run
    place_order_guest = AddGuest.new("smith james", "host id")
    place_order_guest.run

    expect(Order.count).to eq(2)
  end

  it "remove the spaces before and after names" do
    place_order_guest = AddGuest.new(" james smith ", "host id")
    place_order_guest.run

    expect(Order.last.user_name).to eq("james smith")
  end

  it "reccord the name in lowercase" do
    place_order_guest = AddGuest.new("James Smith", "host id")
    place_order_guest.run

    expect(Order.last.user_name).to eq("james smith")
  end
end

