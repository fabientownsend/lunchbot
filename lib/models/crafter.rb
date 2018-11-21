require 'data_mapper'

class User
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :slack_id, String, length: 255
  property :email, String, length: 255
  property :office, String, length: 255
  property :is_foreman, Boolean, :default => false

  def self.with_office
    all(:office.not => nil)
  end

  def self.profile(slack_id)
    User.last(:slack_id => slack_id)
  end

  def self.has_office?(slack_id)
    user = User.last(:slack_id => slack_id)
    !user.office.nil?
  end

  def self.create(user)
    User.new(
      :user_name => user[:user_name],
      :slack_id => user[:user_id],
      :email => user[:user_email],
      :office => user[:office]
    ).save
  end

  def add_office(office)
    self.office = office
    save
  end
end
