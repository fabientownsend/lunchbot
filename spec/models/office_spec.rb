require 'models/office'

RSpec.describe Office do
  it "tells the offices available" do
    expect(Office.list).to eq(["london", "madison"])
  end

  it "tells if an office is part of the list" do
    expect(Office.available?("london")).to eq(true)
  end

  it "tells if an office is not part of the list" do
    expect(Office.available?("new york")).to eq(false)
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

    expect(Order.crafter_without_order("london")).to include(Crafter.profile("the id"))
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

    expect(Order.crafter_without_order("london")).to eq([])
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
