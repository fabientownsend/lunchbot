require 'models/office'

RSpec.describe Office do
  it "tells the offices available" do
    expect(Office.locations).to eq(["london", "madison"])
  end

  it "tells if an office is part of the list" do
    office = Office.new("london")
    expect(office).to be_available
  end

  it "tells if an office is not part of the list" do
    office = Office.new("new york")
    expect(office).not_to be_available
  end
end
