require 'data_mapper'

class Apprentice
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String
  property :slack_id, String
end
