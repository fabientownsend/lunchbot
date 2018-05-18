require 'commands/order/all_food_orders'
require 'date'
require 'days'

RSpec.describe Commands::AllFoodOrders do
  let(:all_food_orders) { Commands::AllFoodOrders.new }

  it "return all food orders when asked" do
    expect(all_food_orders.applies_to(user_message: "all food orders")).to eq(true)
  end

  it "return the total of the different food" do
    place_order("asdf", "will", "burger")
    place_order("qwer", "fabien", "burger")
    place_order("poiu", "james", "fish")

    all_food = "burger: 2\nfish: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "return only the meal of the current week" do
    place_order("asdf", "will", "burger")
    place_order("qwer", "fabien", "burger")
    place_order("poiu", "james", "fish")

    previous_week_order = Order.create(
      user_name: "james",
      lunch: "rice",
      date: previous_week
    )
    previous_week_order.save

    all_food = "burger: 2\nfish: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "return monday orders" do
    place_order("asdf", "will", "burger")

    all_food = "burger: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "return friday orders" do
    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.friday
    )

    all_food = "burger: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "doesn't count guest without orders" do
    Helper.add_guest("james smith")
    Helper.add_guest("smith james ")

    Helper.order(
      user_id: "asdf",
      user_name: "will",
      user_message: "burger",
      date: Days.friday
    )

    all_food = "burger: 1"
    expect(all_food_orders.run).to eq(all_food)
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
