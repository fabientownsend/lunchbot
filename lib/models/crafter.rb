require 'data_mapper'

class Crafter
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :slack_id, String, length: 255
  property :email, String, length: 255
end
