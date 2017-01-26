require 'add_guest'

RSpec.describe AddGuest do
  let(:guest_name) { "Steve Jobs" }

  it "add a new guest to the database" do
    create_new_guest(guest_name)

    expect(Guest.count).to eq(1)
    expect(Guest.last.guest_name).to eq("Steve Jobs")
  end

  it "It doesn't createa a new guest when the name already exist" do
    create_new_guest(guest_name)
    create_new_guest(guest_name)

    expect(Guest.count).to eq(1)
  end

  it "It should add a new guest when a name is different" do
    create_new_guest(guest_name)
    create_new_guest("a different guest name")

    expect(Guest.count).to eq(2)
  end

  it "It update the host id when guest name identical but host different" do
    host_id_one = "asdf"
    host_id_two = "qwerty"
    create_new_guest(guest_name, host_id_one)
    create_new_guest(guest_name, host_id_two)

    expect(Guest.last(:guest_name => "Steve Jobs").host_id).to eq(host_id_two)
    expect(Guest.count).to eq(1)
  end

  it "confirm that the guest got add" do
    cng = create_new_guest(guest_name)

    expect(cng.response?).to be true
    expect(cng.response).to eq("#{guest_name} was added to the list of guest")
  end

  def create_new_guest(guest_name, host_id = "host_id")
    event_data = {user_id: "#{host_id}", user_name: "a name" }
    set_order_command = AddGuest.new(guest_name, event_data)
    set_order_command.run
    set_order_command
  end
end
