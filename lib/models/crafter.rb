require 'data_mapper'

class Crafter
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :slack_id, String, length: 255
  property :email, String, length: 255
  property :office, String, length: 255

  def self.profile(slack_id)
    Crafter.last(:slack_id => slack_id)
  end

  def self.create(user)
    Crafter.new(
      :user_name => user[:user_name],
      :slack_id => user[:user_id],
      :email => user[:user_email]
    ).save
  end

  def add_office(office)
    self.office = office
    save
  end
end
