require 'commands/order/get_all_guests'
require 'commands/order/set_order_command'

RSpec.describe GetAllGuests do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will", user_message: "burger" } }
  let (:guest_provider) { GetAllGuests.new }

  it "return list of guest when only one guest" do
    expect(guest_provider.run).to eq("no guest")
  end

  it "return list of guest when only one guest" do
    guest_order_for("james smith")

    expect(guest_provider.run).to eq("james smith")
  end

  it "return the list of the guests when multiple guests" do
    guest_order_for("james smith")
    guest_order_for("jean bon")

    expect(guest_provider.run).to eq("james smith\njean bon")
  end

  it "doesn't return the crafters" do
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)
    set_order_command.run

    guest_order_for("james smith")
    guest_order_for("jean bon")

    expect(guest_provider.run).to eq("james smith\njean bon")
    expect(Order.last(:user_id => "asdf")).not_to be_nil
  end

  private

  def guest_order_for(name)
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare({user_id: "host id", user_message: "order -#{name}-: burger"})
    place_order_guest.run
  end
end
