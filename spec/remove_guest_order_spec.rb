require 'get_all_guests'
require 'get_all_orders_command'
require 'remove_guest_order'
require 'set_order_command'

RSpec.describe GetAllGuests do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "will" } }
  let (:guest_provider) { GetAllGuests.new }
  let (:get_all_orders) { GetAllOrdersCommand.new }

  it "do nothing when the user name doesn't exist" do
    response = RemoveGuestOrder.new("james smith").run

    expect(response).to eq("james smith doesn't exist!")
  end

  it "remove a guest" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    response = RemoveGuestOrder.new("james smith").run

    expect(guest_provider.run).to eq("jean bon")
    expect(response).to eq("james smith removed")
  end

  it "isn't case sensitive" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    response = RemoveGuestOrder.new("James smith").run

    expect(guest_provider.run).to eq("jean bon")
    expect(response).to eq("james smith removed")
  end

  it "isn't extra space sensitive" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    response = RemoveGuestOrder.new("james smith ").run

    expect(guest_provider.run).to eq("jean bon")
    expect(response).to eq("james smith removed")
  end

  it "doesn't remove a crafter" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    SetOrderCommand.new("burger", event_data_from_will).run

    response = RemoveGuestOrder.new("Will").run

    expect(get_all_orders.run).to eq(
      "james smith: burger\n" +
      "jean bon: burger\n" +
      "will: burger"
    )

    expect(response).to eq("will isn't a guest!")
  end

  private

  def guest_order_for(name)
    place_order_guest = PlaceOrderGuest.new("burger", name, "host id")
    place_order_guest.run
  end
end
