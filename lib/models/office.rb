class Office
  LOCATIONS = ["london", "madison"]

  attr_reader :location

  def initialize(location)
    @location = location
  end

  def self.locations
    LOCATIONS
  end

  def available?
    LOCATIONS.include?(location)
  end
end
