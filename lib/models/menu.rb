require 'data_mapper'

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :url, String, length: 255
  property :date, DateTime
end
