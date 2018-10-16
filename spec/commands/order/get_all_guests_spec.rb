require 'commands/order/get_all_guests'
require 'models/order'

RSpec.describe Commands::GetAllGuests do
  let(:guest_provider) { Commands::GetAllGuests.new }

  it "list of guest when no guest" do
    expect(guest_provider.run).to eq("no guest")
  end

  it "list of guest when only one guest" do
    Helper.order_guest(name: "james smith", meal: "burger")

    expect(guest_provider.run).to eq("james smith")
  end

  it "return the list of the guests when multiple guests" do
    Helper.order_guest(name: "james smith", meal: "burger")
    Helper.order_guest(name: "jean bon", meal: "burger")

    expect(guest_provider.run).to eq("james smith\njean bon")
  end

  it "doesn't return the crafters" do
    Crafter.create(
      user_id: "asdf",
      user_name: "Will",
      office: "london"
    )

    Helper.order(user_id: "asdf", user_name: "Will", user_message: "burger")
    Helper.order_guest(name: "james smith", meal: "burger")
    Helper.order_guest(name: "jean bon", meal: "burger")

    expect(guest_provider.run).to eq("james smith\njean bon")
    expect(Order.last(user_id: "asdf")).not_to be_nil
  end

  it "return the guest of the current week" do
    Helper.order_guest_previous_monday(name: "jean gaston", meal: "burger")
    Helper.order_guest(name: "james smith", meal: "burger")
    Helper.order_guest(name: "jean bon", meal: "burger")

    expect(guest_provider.run).to eq("james smith\njean bon")
  end
end
