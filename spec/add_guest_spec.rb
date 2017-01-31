require 'add_guest'

RSpec.describe AddGuest do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will" } }

  it "save a guest" do
    response = add_guest("james smith")

     expect(Order.count).to eq(1)
     expect(response).to eq("james smith added")
  end

  it "said if a guest already exist" do
    response = add_guest("james smith")
    response = add_guest("james smith")

    expect(Order.count).to eq(1)
    expect(response).to eq("james smith already exist")
  end

  it "add different guest" do
    add_guest("james smith")
    add_guest("smith james ")

    expect(Order.count).to eq(2)
  end

  it "remove the spaces before and after names" do
    add_guest("james smith  ")

    expect(Order.last.user_name).to eq("james smith")
  end

  it "reccord the name in lowercase" do
    add_guest("James Smith")

    expect(Order.last.user_name).to eq("james smith")
  end

  private

  def add_guest(name)
    place_order_guest = AddGuest.new
    place_order_guest.prepare({
      user_message: "add guest: #{name}",
      user_id: "host id"
    })
    place_order_guest.run
  end
end
