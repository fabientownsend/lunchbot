class Office
  @offices = ["london", "madisson"]

  def self.list
    @offices
  end

  def self.available?(office)
    @offices.include?(office)
  end
end
