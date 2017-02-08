require 'commands/foreman/add_apprentice'
require 'commands/order/add_guest'
require 'commands/order/place_order_guest'
require 'commands/order/set_order_command'
require 'coveralls'
require 'models/crafter'
require 'data_mapper'
require 'date'
require 'days'

Coveralls.wear!

class Helper
  def self.order(data)
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(data)
    set_order_command.run
  end

  def self.order_previous_monday(data)
    data[:date] = Days.monday - 8
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(data)
    set_order_command.run
  end

  def self.order_guest(data)
    from = data[:from] || "host id"
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare({
      user_id: from, user_message: "order -#{data[:name]}-: #{data[:meal]}"
    })
    place_order_guest.run
  end

  def self.order_guest_previous_monday(data)
    from = data[:from] || "host id"
    place_order_guest = PlaceOrderGuest.new
    place_order_guest.prepare({
      user_id: from,
      user_message: "order -#{data[:name]}-: #{data[:meal]}",
      date: Days.monday - 8
    })
    place_order_guest.run
  end

  def self.add_guest(name)
    place_order_guest = AddGuest.new
    place_order_guest.prepare({
      user_message: "add guest: #{name}",
      user_id: "host id"
    })
    place_order_guest.run
  end

  def self.add_guest_previous_monday(name)
    place_order_guest = AddGuest.new
    place_order_guest.prepare({
      user_message: "add guest: #{name}",
      user_id: "host id",
      date: Days.monday - 8
    })
    place_order_guest.run
  end

  def self.add_foreman(data)
    id = data[:id]
    user_name = data[:name]
    add_apprentice = AddApprentice.new
    add_apprentice.prepare({user_id: id, user_name: user_name})
    add_apprentice.run
  end
end

RSpec.configure do |config|
  DataMapper.setup(:default, 'sqlite::memory:')

  config.before(:each) do
    DataMapper.finalize.auto_migrate!

    crafter = Crafter.new(
      user_name: "Fabien",
      slack_id: "FabienUserId"
    )
    crafter.save

    crafter = Crafter.new(
      user_name: "Will",
      slack_id: "WillUserId"
    )
    crafter.save
  end
end

