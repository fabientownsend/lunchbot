require 'commands/order/all_food_orders'
require 'date'
require 'days'

RSpec.describe Commands::AllFoodOrders do
  let(:all_food_orders) { Commands::AllFoodOrders.new }

  it "return all food orders when asked" do
    expect(all_food_orders.applies_to?(user_message: "all food orders")).to eq(true)
  end

  it "return the total of the different food" do
    User.create(user_id: "asdf", user_name: "will", office: "london")
    User.create(user_id: "qwer", user_name: "fabien", office: "london")
    User.create(user_id: "poiu", user_name: "james", office: "london")
    place_order("asdf", "will", "burger")
    place_order("qwer", "fabien", "burger")
    place_order("poiu", "james", "fish")

    all_food_orders.prepare(user_id: "asdf")

    expect(all_food_orders.run).to eq("Burger: 2\nFish: 1")
  end

  it "return only the meal of the current week" do
    User.create(user_id: "asdf", user_name: "will", office: "london")
    User.create(user_id: "qwer", user_name: "fabien", office: "london")
    User.create(user_id: "poiu", user_name: "james", office: "london")
    place_order("asdf", "will", "burger")
    place_order("qwer", "fabien", "burger")
    place_order("poiu", "james", "fish")

    Order.new(
      user_name: "james",
      lunch: "rice",
      date: previous_week
    ).save

    all_food_orders.prepare(user_id: "asdf")

    expect(all_food_orders.run).to eq("Burger: 2\nFish: 1")
  end

  it "return monday orders" do
    User.create(user_id: "asdf", user_name: "will", office: "london")
    place_order("asdf", "will", "burger")

    all_food_orders.prepare(user_id: "asdf")

    expect(all_food_orders.run).to eq("Burger: 1")
  end

  it "return friday orders" do
    User.create(user_id: "asdf", user_name: "will", office: "london")
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.friday
    )

    all_food_orders.prepare(user_id: "asdf")

    expect(all_food_orders.run).to eq("Burger: 1")
  end

  it "doesn't count guest without orders" do
    Helper.add_guest("james smith")
    Helper.add_guest("smith james ")

    User.create(user_id: "asdf", user_name: "will", office: "london")
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.friday
    )

    all_food_orders.prepare(user_id: "asdf")

    expect(all_food_orders.run).to eq("Burger: 1")
  end

  private

  def previous_week
    Date.today - 8
  end

  def place_order(id, name, meal)
    Helper.order(
      user_id: id,
      user_name: name,
      user_message: meal,
      date: Days.monday
    )
  end
end
