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

  def self.place(order)
    Order.new(
      :user_name => order[:user_name],
      :user_id => order[:user_id],
      :lunch => order[:lunch],
      :date => order[:date] || Date.today
    ).save
  end

  def self.placed_for(user_id)
    Order.last(
      :user_id => user_id,
      :date => Days.from_monday_to_friday
    )
  end

  def update_lunch(lunch)
    self.lunch = lunch
    save
  end
end
