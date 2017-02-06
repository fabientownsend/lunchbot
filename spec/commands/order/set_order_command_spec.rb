require 'commands/order/set_order_command'
require 'models/order'

RSpec.describe SetOrderCommand do
  it "reccord an order in the database" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})

    expect(Order.last(:user_name => "will").lunch).to eq("burger")
  end

  it "udpate the order of the current week" do
    Helper.order_previous_monday({
      user_id: "asdf",
      user_name: "james",
      user_message: "fish"
      })
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})
    Helper.order({user_id: "asdf", user_name: "will", user_message: "fish"})

    expect(Order.last(:user_name => "will").lunch).to eq("fish")
  end

  it "save different order when user id is different" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})
    Helper.order({user_id: "qwer", user_name: "fabien", user_message: "fish"})

    expect(Order.last(:user_name => "will").lunch).to eq("burger")
    expect(Order.last(:user_name => "fabien").lunch).to eq("fish")
  end

  it "create a new order if none this current week" do
    Helper.order_previous_monday({
      user_id: "asdf",
      user_name: "james",
      user_message: "fish"
    })
    Helper.order({user_id: "asdf", user_name: "james", user_message: "burger"})

    expect(Order.first(:user_name => "james").lunch).to eq("fish")
    expect(Order.last(:user_name => "james").lunch).to eq("burger")
  end
end
