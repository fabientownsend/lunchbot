require 'models/order'
require 'models/user'
require 'date'

RSpec.describe Order do
  before do
    @user_id_london = "user id london"
    @user_id_new_work =  "user id new york"
    User.create(user_id: @user_id_london, office: "london")
    User.create(user_id: @user_id_new_work, office: "new york")
  end

  it "only returns order from office requested" do
    Order.place(
      :user_name => "Tom",
      :user_id => @user_id_new_work,
      :lunch => "A lunch",
      :date => Days.monday
    )
    order = Order.new(
      :user_name => "Tom",
      :user_id => @user_id_london,
      :lunch => "A lunch",
      :date => Days.monday
    )
    order.save

    expect(Order.placed_in("london")).to include(order)
  end

  it "does not include order from a different office" do
    excluded_order = {
      :user_name => "Tom",
      :user_id => @user_id_new_york,
      :lunch => "A lunch",
      :date => Days.monday,
    }
    Order.place(excluded_order)

    Order.place(
      :user_name => "Tom",
      :user_id => @user_id_london,
      :lunch => "A lunch",
      :date => Days.monday
    )

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

  context "order from previous week" do
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
end
