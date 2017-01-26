require 'data_mapper'

class Guest
  include DataMapper::Resource

  property :id, Serial
  property :guest_name, String
  property :host_id, String
end
