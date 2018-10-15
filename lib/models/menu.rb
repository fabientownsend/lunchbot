require 'data_mapper'

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :url, String, length: 255
  property :date, DateTime
  property :office, String, length: 255

  def self.url_to_menu_for(office)
    Menu.last(:office => office).url if Menu.last(:office => office)
  end
end
