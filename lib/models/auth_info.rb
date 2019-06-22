# typed: true
require 'data_mapper'

class AuthInfo
  include DataMapper::Resource

  property :id, Serial
  property :bot_token, String, length: 255
  property :bot_id, String, length: 255
  property :user_token, String, length: 255
end
