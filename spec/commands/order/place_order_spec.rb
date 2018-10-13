require 'commands/order/place_order'
require 'models/order'
require 'models/crafter'

RSpec.describe Commands::PlaceOrder do
  it "reccord an order in the database" do
    Helper.order(user_id: "asdf", user_name: "will", user_message: "burger")

    expect(Order.last(user_name: "will").lunch).to eq("burger")
  end

  it "udpate the order of the current week" do
    Helper.order_previous_monday(
      user_id: "asdf",
      user_name: "james",
      user_message: "fish"
    )
    Helper.order(user_id: "asdf", user_name: "will", user_message: "burger")
    Helper.order(user_id: "asdf", user_name: "will", user_message: "fish")

    expect(Order.last(user_name: "will").lunch).to eq("fish")
  end

  it "save different order when user id is different" do
    Helper.order(user_id: "asdf", user_name: "will", user_message: "burger")
    Helper.order(user_id: "qwer", user_name: "fabien", user_message: "fish")

    expect(Order.last(user_name: "will").lunch).to eq("burger")
    expect(Order.last(user_name: "fabien").lunch).to eq("fish")
  end

  it "create a new order if none this current week" do
    Helper.order_previous_monday(
      user_id: "asdf",
      user_name: "james",
      user_message: "fish"
    )
    Helper.order(user_id: "asdf", user_name: "james", user_message: "burger")

    expect(Order.first(user_name: "james").lunch).to eq("fish")
    expect(Order.last(user_name: "james").lunch).to eq("burger")
  end

  it "save the user in the database if he doesn't exist" do
    Helper.order(
      user_id: "asdf",
      user_name: "crouton",
      user_message: "burger",
      user_email: "email@email.com"
    )

    expect(Crafter.last(slack_id: "asdf")).not_to eq(nil)
    expect(Crafter.last(email: "email@email.com")).not_to eq(nil)
  end

  it "update users without email" do
    expect(Crafter.last(slack_id: "FabienUserId").email).to eq(nil)

    Helper.order(
      user_id: "FabienUserId",
      user_name: "Fabien",
      user_message: "burger",
      user_email: "fabien@email.com"
    )

    expect(Crafter.last(slack_id: "FabienUserId").email) .to eq("fabien@email.com")
  end

  it "Ask user to add location when user do not have a location" do
    expect(Crafter.last(slack_id: "FabienUserId").office).to eq(nil)

    place_order = Commands::PlaceOrder.new
    place_order.prepare(
      user_message: "burger",
      user_name: "Fabien Townsend",
      user_id: "FabienUserId"
    )

    expect(place_order.run) .to eq("You need to add your office. ex: \"office: london\"")
  end

  it "does not place an order if lunch is empty" do
    place_order = Commands::PlaceOrder.new
    place_order.prepare(
      user_message: "",
      user_name: "Fabien Townsend",
      user_id: "FabienUserId"
    )

    expect(place_order.run) .to eq("That is not a valid order.")
  end
end
