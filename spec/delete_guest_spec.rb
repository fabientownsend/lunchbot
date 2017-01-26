require 'delete_guest'
require 'add_guest'

RSpec.describe AddGuest do
  let(:guest_name) { "Steve Jobs" }

  it "can delete an existing guest" do
    create_new_guest(guest_name)
    delete_guest = delete_guest(guest_name)
    expect(Guest.count).to eq(0)
    expect(delete_guest.response).to eq("#{guest_name} was deleted")
  end

  it "nothing happend when user doesn't exist" do
    create_new_guest(guest_name)
    delete_guest = delete_guest("no one")
    expect(Guest.count).to eq(1)
    expect(delete_guest.response).to eq("no one wasn't found")
  end

  private

  def create_new_guest(guest_name, host_id = "host_id")
    event_data = {user_id: "#{host_id}", user_name: "a name" }
    set_order_command = AddGuest.new(guest_name, event_data)
    set_order_command.run
    set_order_command
  end

  def delete_guest(guest_name, host_id = "host_id")
    set_order_command = DeleteGuest.new(guest_name)
    set_order_command.run
    set_order_command
  end
end
