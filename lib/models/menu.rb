require 'data_mapper'

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :url, String, length: 255
  property :date, DateTime
  property :office, String, length: 255

  def self.selected_for(office)
    Menu.last(:office => office)
  end
end
