# typed: false
require 'data_mapper'
require 'date'
require 'days'

class Order
  include DataMapper::Resource

  property :id, Serial
  property :user_name, String, length: 255
  property :lunch, String, length: 255
  property :date, DateTime

  property :user_id, String

  property :host, String

  def self.placed_in(office)
    orders = all(:date => Days.from_monday_to_friday)
    users = User.all(:office => office)

    orders.keep_if do |order|
      users.any? { |user| user.slack_id == order.user_id || user.slack_id == order.host }
    end
  end

  def self.place(order)
    new(
      :user_name => order[:user_name],
      :user_id => order[:user_id],
      :lunch => order[:lunch],
      :date => order[:date] || Date.today
    ).save
  end

  def self.placed_for(user_id)
    last(
      :user_id => user_id,
      :date => Days.from_monday_to_friday
    )
  end

  def update_lunch(lunch)
    self.lunch = lunch
    save
  end

  def self.users_without_order(office)
    orders = all(:date => Days.from_monday_to_friday)
    users = User.all(:office => office)
    users.delete_if { |c| orders.any? { |o| o.user_id == c.slack_id } }
  end

  def self.guests_without_order(office)
    orders = all(:date => Days.from_monday_to_friday, :host.not => nil, :lunch => nil)
    users = User.all(:office => office)

    orders.keep_if do |order|
      users.any? { |user| user.slack_id == order.host }
    end
  end
end
