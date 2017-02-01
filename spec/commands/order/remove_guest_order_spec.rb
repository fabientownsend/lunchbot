require 'commands/order/get_all_guests'
require 'commands/order/get_all_orders_command'
require 'commands/order/remove_guest_order'
require 'commands/order/set_order_command'

RSpec.describe GetAllGuests do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "will", user_message: "burger"} }
  let (:guest_provider) { GetAllGuests.new }
  let (:get_all_orders) { GetAllOrdersCommand.new }

  it "do nothing when the user name doesn't exist" do
    remove_guest_order = RemoveGuestOrder.new
    remove_guest_order.prepare({user_message: "remove guest: james smith"})
    response = remove_guest_order.run

    expect(response).to eq("james smith doesn't exist!")
  end

  it "remove a guest" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    remove_guest_order = RemoveGuestOrder.new
    remove_guest_order.prepare({user_message: "remove guest: james smith"})
    response = remove_guest_order.run

    expect(guest_provider.run).to eq("jean bon")
    expect(response).to eq("james smith removed")
  end

  it "isn't case sensitive" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    remove_guest_order = RemoveGuestOrder.new
    remove_guest_order.prepare({user_message: "remove guest: James Smith"})
    response = remove_guest_order.run

    expect(guest_provider.run).to eq("jean bon")
    expect(response).to eq("james smith removed")
  end

  it "isn't extra space sensitive" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    remove_guest_order = RemoveGuestOrder.new
    remove_guest_order.prepare({user_message: "remove guest: james smith "})
    response = remove_guest_order.run

    remove_guest_order.prepare({user_message: "remove guest: jean bon"})
    expect(response).to eq("james smith removed")
  end

  it "doesn't remove a crafter" do
    guest_order_for("james smith")
    guest_order_for("jean bon")
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(event_data_from_will)
    set_order_command.run

    remove_guest_order = RemoveGuestOrder.new
    remove_guest_order.prepare({user_message: "remove guest: will"})
    response = remove_guest_order.run

    expect(get_all_orders.run).to eq(
      "james smith: burger\n" +
      "jean bon: burger\n" +
      "will: burger"
    )

    expect(response).to eq("will isn't a guest!")
  end

  private

  def guest_order_for(name)
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare({user_id: "host id", user_message: "order - #{name}-: burger"})
    place_order_guest.run
  end
end
