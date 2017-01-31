require 'data_mapper'

class Order
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String
  property :lunch, String
  property :date, DateTime

  property :user_id, String

  property :host, String
end
