require 'commands/order/get_all_orders_command'
require 'models/order'
require 'models/crafter'
require 'date'
require 'days'

RSpec.describe Commands::GetAllOrders do
  let(:get_all_orders_command) { Commands::GetAllOrders.new }

  it "returns no orders" do
    expect(get_all_orders_command.run).to eq("no orders")
  end

  it "return all order with a new line for each orders" do
    Helper.order(
      user_id: "qwer",
      user_name: "fabien",
      user_message: "fish",
      date: Days.monday
    )
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )

    response = get_all_orders_command.run
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "returns orders passed the monday" do
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )

    response = get_all_orders_command.run
    list_all_orders = "will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "the order are returned sorted by name" do
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )
    Helper.order(
      user_id: "qwer",
      user_name: "fabien",
      user_message: "fish",
      date: Days.monday
    )

    response = get_all_orders_command.run
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return only the orders of the current week" do
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )
    Helper.order(
      user_id: "qwer",
      user_name: "fabien",
      user_message: "fish",
      date: Days.monday
    )

    previous_week_order = Order.create(
      user_name: "james",
      lunch: "rice",
      date: previous_week
    )
    previous_week_order.save

    response = get_all_orders_command.run
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "returns names based on the crafter database" do
    Helper.order(
      user_id: "asdf",
      user_name: "no name",
      user_message: "burger",
      date: Days.monday
    )
    Helper.order(
      user_id: "qwer",
      user_name: "no name",
      user_message: "fish",
      date: Days.monday
    )

    crafter = Crafter.last(slack_id: "asdf")
    crafter.user_name = "will"
    crafter.save

    crafter = Crafter.last(slack_id: "qwer")
    crafter.user_name = "fabien"
    crafter.save

    response = get_all_orders_command.run
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "returns order name from a guest" do
    Helper.order(
      user_id: "asdf",
      user_name: "no name",
      user_message: "burger",
      date: Days.monday
    )
    Helper.order(
      user_id: "qwer",
      user_name: "no name",
      user_message: "fish",
      date: Days.monday
    )

    Helper.order_guest(name: "james smith", meal: "burger")

    crafter = Crafter.last(slack_id: "asdf")
    crafter.user_name = "will"
    crafter.save

    crafter = Crafter.last(slack_id: "qwer")
    crafter.user_name = "fabien"
    crafter.save

    response = get_all_orders_command.run
    list_all_orders = "fabien: fish\njames smith: burger\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  private

  def previous_week
    Date.today - 8
  end
end
