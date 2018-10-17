require 'data_mapper'

class Order
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :lunch, String, length: 255
  property :date, DateTime

  property :user_id, String

  property :host, String

  def self.placed_in(office)
    orders = Order.all(:date => Days.from_monday_to_friday)
    crafter = Crafter.all(:office => office)
    orders.keep_if { |o| crafter.any? { |c| c.slack_id == o.user_id } }
  end
end
