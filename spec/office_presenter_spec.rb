require 'office_presenter'

RSpec.describe OfficePresenter do
  describe ".locations" do
    it "formats locations" do
      stub_const("Office::LOCATIONS", ["foo", "bar", "baz"])
      expect(OfficePresenter.locations).to eql "Foo, Bar, Baz"
    end
  end
end
