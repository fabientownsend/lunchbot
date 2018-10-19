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
end
