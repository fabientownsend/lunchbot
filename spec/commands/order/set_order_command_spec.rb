require 'commands/order/set_order_command'
require 'models/order'

RSpec.describe SetOrderCommand do
  it "reccord an order in the database" do
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})

    expect(Order.last(:user_name => "will").lunch).to eq("burger")
  end

  it "update the order when the user id already exist" do
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
end
