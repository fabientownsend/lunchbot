require 'commands/order/all_food_orders'
require 'date'
require 'days'

RSpec.describe AllFoodOrders do
  let (:all_food_orders) { AllFoodOrders.new }

  it "return all food orders when asked" do
    expect(all_food_orders.applies_to("all food orders")).to eq(true)
  end

  it "return the total of the different food" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "burger", date: Days.monday})
    Helper.order({user_id: "poiu", user_name: "james", user_message: "fish", date: Days.monday})

    all_food = "burger: 2\nfish: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "return only the meal of the current week" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.monday})
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "burger", date: Days.monday})
    Helper.order({user_id: "poiu", user_name: "james", user_message: "fish", date: Days.monday})

    previous_week_order = Order.create(
      :user_name => "james",
      :lunch => "rice",
      :date => previous_week
    )
    previous_week_order.save

    all_food = "burger: 2\nfish: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "return monday orders" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})

    all_food = "burger: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  it "return friday orders" do
    puts Days.friday
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger", date: Days.friday})

    all_food = "burger: 1"
    expect(all_food_orders.run).to eq(all_food)
  end

  private

  def previous_week
    Date.today - 8
  end
end
