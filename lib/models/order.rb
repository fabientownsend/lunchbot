require 'data_mapper'

class Order
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :lunch, String, length: 255
  property :date, DateTime

  property :user_id, String

  property :host, String
end
