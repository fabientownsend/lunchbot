class OfficePresenter
  def initialize(office)
    @office = office
  end

  def self.locations
    Office.locations.map(&:capitalize).join(", ")
  end
end
