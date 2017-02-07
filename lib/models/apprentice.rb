require 'data_mapper'

class Apprentice
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, :length => 255
  property :slack_id, String, :length => 255
end
