require 'models/order'
require 'models/crafter'
require 'date'

RSpec.describe Order do
  it "only returns order from office requested" do
    Crafter.create(user_id: "the id", office: "london")
    Crafter.create(user_id: "bob id", office: "new york")
    Order.new(
      :user_name => "Tom",
      :user_id => "bob id",
      :lunch => "A lunch",
      :date => Days.monday
    ).save
    order = Order.new(
      :user_name => "Tom",
      :user_id => "the id",
      :lunch => "A lunch",
      :date => Days.monday
    )
    order.save

    expect(Order.placed_in("london")).to include(order)
  end

  it "does not include order from a different office" do
    Crafter.create(user_id: "the id", office: "london")
    Crafter.create(user_id: "bob id", office: "new york")
    excluded_order = Order.new(
      :user_name => "Tom",
      :user_id => "bob id",
      :lunch => "A lunch",
      :date => Days.monday
    )
    excluded_order.save
    Order.new(
      :user_name => "Tom",
      :user_id => "the id",
      :lunch => "A lunch",
      :date => Days.monday
    ).save

    expect(Order.placed_in("london")).not_to include(excluded_order)
  end
end
