# typed: false
require 'days'

RSpec.describe Days do
  it "return a range of date between monday and friday" do
    Days.from_monday_to_friday.each do |day|
      expect(day.sunday?).to eq(false)
      expect(day.saturday?).to eq(false)
    end
  end
end
