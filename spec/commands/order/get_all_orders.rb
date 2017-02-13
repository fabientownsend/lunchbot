require 'commands/order/get_all_orders'
require 'models/order'
require 'date'
require 'days'

RSpec.describe GetAllOrdersCommand do
  let (:get_all_orders_command) { GetAllOrders.new }

  it "returns no orders" do
    expect(get_all_orders_command.run).to eq("no orders")
  end

  it "returns all orders when its returned" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})

    response = get_all_orders_command.run()
    list_all_orders = "will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return all order with a new line for each orders" do
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "fish", date: Days.monday})
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})

    response = get_all_orders_command.run()
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end


  it "returns orders passed the monday" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})

    response = get_all_orders_command.run()
    list_all_orders = "will: burger"
    expect(response).to eq(list_all_orders)
  end

  it "the order are returned sorted by name" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "fish", date: Days.monday})

    response = get_all_orders_command.run()
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  it "return only the orders of the current week" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "fish", date: Days.monday})

    previous_week_order = Order.create(
      :user_name => "james",
      :lunch => "rice",
      :date => previous_week
    )
    previous_week_order.save

    response = get_all_orders_command.run()
    list_all_orders = "fabien: fish\nwill: burger"
    expect(response).to eq(list_all_orders)
  end

  private

  def previous_week
    Date.today - 8
  end
end
