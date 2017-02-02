require 'date'

class Days
  def self.from_monday_to_friday
    monday..friday
  end

  private

  def self.monday
    Date.today - Date.today.wday + 1
  end

  def self.friday
    Date.today + (5 - Date.today.wday)
  end
end
