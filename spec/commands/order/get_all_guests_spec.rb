require 'commands/order/get_all_guests'
require 'spec_helper'

RSpec.describe GetAllGuests do
  let (:guest_provider) { GetAllGuests.new }

  it "return list of guest when only one guest" do
    expect(guest_provider.run).to eq("no guest")
  end

  it "return list of guest when only one guest" do
    Helper.order_guest({name: "james smith", meal: "burger"})

    expect(guest_provider.run).to eq("james smith")
  end

  it "return the list of the guests when multiple guests" do
    Helper.order_guest({name: "james smith", meal: "burger"})
    Helper.order_guest({name: "jean bon", meal: "burger"})

    expect(guest_provider.run).to eq("james smith\njean bon")
  end

  it "doesn't return the crafters" do
    Helper.order({user_id: "asdf", user_name: "Will", user_message: "burger"})
    Helper.order_guest({name: "james smith", meal: "burger"})
    Helper.order_guest({name: "jean bon", meal: "burger"})

    expect(guest_provider.run).to eq("james smith\njean bon")
    expect(Order.last(:user_id => "asdf")).not_to be_nil
  end
end
