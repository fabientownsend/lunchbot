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

  it "returns user without order" do
    Crafter.create(user_id: "the id", office: "london")
    Crafter.create(user_id: "bob id", office: "london")
    Order.new(
      :user_name => "Tom",
      :user_id => "bob id",
      :lunch => "A lunch",
      :date => Days.monday
    ).save

    expect(Order.have_not_ordered("london")).to include(Crafter.profile("the id"))
  end

  it "returns empty array if every crafter ordered a lunch" do
    Crafter.all.destroy
    Crafter.create(user_id: "the id", office: "london")

    Order.new(
      :user_name => "Tom",
      :user_id => "the id",
      :lunch => "A lunch",
      :date => Days.monday
    ).save

    expect(Order.have_not_ordered("london")).to eq([])
  end

  it "returns guest's name and host when without order" do
    Crafter.create(user_id: "from london", office: "london")
    Crafter.create(user_id: "bob id", office: "london")
    Order.new(
      :user_name => "Tom",
      :user_id => "bob id",
      :lunch => "A lunch",
      :host => "from london",
      :date => Days.monday
    ).save

    Order.new(
      :user_name => "Tom",
      :user_id => "the id",
      :host => "from london",
      :date => Days.monday
    ).save

    expect(Order.host_without_order("london")).to eq(Order.all(user_id: "the id"))
  end

  it "keeps guest for a specific office" do
    Crafter.create(user_id: "from london", office: "london")
    Crafter.create(user_id: "from new york", office: "new york")
    Order.new(
      :user_name => "Tom",
      :user_id => "bob id",
      :host => "from london",
      :date => Days.monday
    ).save

    Order.new(
      :user_name => "Tom",
      :user_id => "the id",
      :host => "from new york",
      :date => Days.monday
    ).save

    expect(Order.host_without_order("london")).to eq(Order.all(user_id: "bob id"))
  end
end
