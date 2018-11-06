require 'data_mapper'

class Apprentice
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :slack_id, String, length: 255
  property :office, String, length: 255

  def self.profile(slack_id)
    Apprentice.last(:slack_id => slack_id)
  end

  def add_office(office)
    self.office = office
    save
  end

  def self.create(user)
    Apprentice.new(
      :user_name => user[:user_name],
      :slack_id => user[:user_id],
      :office => user[:office]
    ).save
  end

  def self.foreman_for_office(office)
    apprentice = Apprentice.first(:office => office)
    apprentice
  end
end
