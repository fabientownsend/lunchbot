class Office
  @offices = ["london", "madison"]

  def self.list
    @offices
  end

  def self.available?(office)
    @offices.include?(office)
  end
end
