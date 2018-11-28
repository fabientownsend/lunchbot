ENV['RACK_ENV'] = 'test'
require 'commands/foreman/add_apprentice'
require 'commands/order/add_guest'
require 'commands/order/place_order_guest'
require 'commands/order/place_order'
require 'coveralls'
require 'models/user'
require 'data_mapper'
require 'date'
require 'days'

Coveralls.wear!

class Helper
  def self.order(data)
    set_order_command = Commands::PlaceOrder.new
    set_order_command.prepare(data)
    set_order_command.run
  end

  def self.order_previous_monday(data)
    data[:date] = Days.monday - 8
    set_order_command = Commands::PlaceOrder.new
    set_order_command.prepare(data)
    set_order_command.run
  end

  def self.order_guest(data)
    from = data[:from] || "host id"
    place_order_guest = Commands::PlaceOrderGuest.new
    place_order_guest.prepare(
      user_id: from,
      user_message: "order -#{data[:name]}-: #{data[:meal]}",
      date: Days.monday
    )
    place_order_guest.run
  end

  def self.order_guest_previous_monday(data)
    from = data[:from] || "host id"
    place_order_guest = Commands::PlaceOrderGuest.new
    place_order_guest.prepare(
      user_id: from,
      user_message: "order -#{data[:name]}-: #{data[:meal]}",
      date: Days.monday - 8
    )
    place_order_guest.run
  end

  def self.add_guest(name)
    place_order_guest = Commands::AddGuest.new
    place_order_guest.prepare(
      user_message: "add guest: #{name}",
      user_id: "host id",
      date: Days.monday
    )
    place_order_guest.run
  end

  def self.add_guest_previous_monday(name)
    place_order_guest = Commands::AddGuest.new
    place_order_guest.prepare(
      user_message: "add guest: #{name}",
      user_id: "host id",
      date: Days.monday - 8
    )
    place_order_guest.run
  end

  def self.add_foreman(data)
    User.create(user_name: data[:name], user_id: data[:id], office: "london")
    id = data[:id]
    user_name = data[:name]
    add_apprentice = Commands::AddApprentice.new
    add_apprentice.prepare(user_id: id, user_name: user_name)
    add_apprentice.run
  end
end

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.filter_gems_from_backtrace 'rack', 'rack-test', 'sinatra'
  config.order = :random

  DataMapper.setup(:default, "sqlite::memory:")

  config.before(:each) do
    DataMapper.finalize.auto_migrate!

    crafter = User.new(
      user_name: "Fabien",
      slack_id: "FabienUserId",
      office: "london"
    )
    crafter.save

    crafter = User.new(
      user_name: "Will",
      slack_id: "WillUserId",
      office: "london"
    )
    crafter.save
  end
end
