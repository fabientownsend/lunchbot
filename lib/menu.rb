require 'data_mapper'

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :url, String
  property :date, DateTime
end
