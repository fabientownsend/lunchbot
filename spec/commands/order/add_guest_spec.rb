require 'commands/order/add_guest'
require 'models/order'

RSpec.describe AddGuest do
  let (:event_data_from_will) { {user_id: "asdf", user_name: "Will" } }

  it "save a guest" do
    response = Helper.add_guest("james smith")

     expect(Order.last(:user_name => "james smith")).not_to be(nil)
     expect(response).to eq("james smith has been added as a guest!")
  end

  it "said if a guest already exist" do
    response = Helper.add_guest("james smith")
    response = Helper.add_guest("james smith")

    expect(Order.count).to eq(1)
    expect(response).to eq("james smith already exist")
  end

  it "add different guest" do
    Helper.add_guest("james smith")
    Helper.add_guest("smith james ")

    expect(Order.count).to eq(2)
  end

  it "remove the spaces before and after names" do
    Helper.add_guest("  james smith  ")

    expect(Order.last.user_name).to eq("james smith")
  end

  it "reccord the name in lowercase" do
    Helper.add_guest("JAMES SMITH")

    expect(Order.last.user_name).to eq("james smith")
  end

  it "add the guest for the current week" do
    Helper.add_guest_previous_monday("JAMES SMITH")
    response = Helper.add_guest("JAMES SMITH")

    expect(response).to eq("james smith has been added as a guest!")
    expect(Order.count(:user_name)).to eq(2)
  end
end
