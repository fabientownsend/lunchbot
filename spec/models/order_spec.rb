require 'models/order'
require 'models/user'
require 'date'

RSpec.describe Order do
  it "only returns order from office requested" do
    User.create(user_id: "the id", office: "london")
    User.create(user_id: "bob id", office: "new york")
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
    User.create(user_id: "the id", office: "london")
    User.create(user_id: "bob id", office: "new york")
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

  it "can find an order placed in the current week" do
    order = {
      user_name: "bob",
      user_id: "an id",
      lunch: "burger",
      date: Days.monday,
    }
    Order.place(order)

    expect(Order.placed_for("an id")).to have_attributes(order)
  end

  it "does return nil when no order found for the current week" do
    expect(Order.placed_for("an id")).to eq(nil)
  end

  it "not find an order from previous week" do
    order = {
      user_name: "bob",
      user_id: "an id",
      lunch: "burger",
      date: Days.monday - 1,
    }
    Order.place(order)

    expect(Order.placed_for("an id")).to eq(nil)
  end
end
