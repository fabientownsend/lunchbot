require 'get_all_guests'
require 'add_guest'

RSpec.describe AddGuest do

  it "return list of guest when only one guest" do
    get_all_guests = GetAllGuests.new
    get_all_guests.run

    expect(get_all_guests.response).to eq("no guest")
  end

  it "return list of guest when only one guest" do
    create_new_guest("Will")

    get_all_guests = GetAllGuests.new
    get_all_guests.run

    expect(get_all_guests.response).to eq("Will")
  end

  it "return the list of the guests when multiple guests" do
    create_new_guest("Will")
    create_new_guest("Fabien")

    get_all_guests = GetAllGuests.new
    get_all_guests.run

    expect(get_all_guests.response).to eq("Will\nFabien")
  end

  def create_new_guest(guest_name, host_id = "host_id")
    event_data = {user_id: "#{host_id}", user_name: "a name" }
    set_order_command = AddGuest.new(guest_name, event_data)
    set_order_command.run
    set_order_command
  end
end
