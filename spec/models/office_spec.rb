require 'models/office'

RSpec.describe Office do
  it "tells the offices available" do
    expect(Office.locations).to eq(["london", "madison"])
  end

  it "tells if an office is part of the list" do
    expect(Office.new("london")).to be_available
  end

  it "tells if an office is not part of the list" do
    expect(Office.new("new york")).not_to be_available
  end

  it "returns user without order" do
    User.create(user_id: "the id", office: "london")
    User.create(user_id: "bob id", office: "london")
    Order.new(
      :user_name => "Tom",
      :user_id => "bob id",
      :lunch => "A lunch",
      :date => Days.monday
    ).save

    expect(Order.users_without_order("london")).to include(User.profile("the id"))
  end

  it "returns empty array if every crafter ordered a lunch" do
    User.all.destroy
    User.create(user_id: "the id", office: "london")

    Order.new(
      :user_name => "Tom",
      :user_id => "the id",
      :lunch => "A lunch",
      :date => Days.monday
    ).save

    expect(Order.users_without_order("london")).to eq([])
  end

  it "returns guest's name and host when without order" do
    User.create(user_id: "from london", office: "london")
    User.create(user_id: "bob id", office: "london")
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

    expect(Order.guests_without_order("london")).to eq(Order.all(user_id: "the id"))
  end

  it "keeps guest for a specific office" do
    User.create(user_id: "from london", office: "london")
    User.create(user_id: "from new york", office: "new york")
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

    expect(Order.guests_without_order("london")).to eq(Order.all(user_id: "bob id"))
  end
end
