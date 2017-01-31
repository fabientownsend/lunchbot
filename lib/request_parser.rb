require 'commands/apprentice_rota'
require 'commands/error_command'
require 'commands/get_order_command'
require 'commands/foreman_command'
require 'commands/get_menu_command'
require 'commands/get_all_guests'
require 'commands/get_all_orders_command'
require 'commands/reminder'
require 'commands/set_menu_command'
require 'commands/set_order_command'
require 'commands/place_order_guest'
require 'commands/remove_guest_order'
require 'commands/add_guest'

class RequestParser
  def initialize()
    @commands = [
      SetMenuCommand.new,
      GetMenuCommand.new,
      Reminder.new,
      GetAllOrdersCommand.new,
      GetAllGuests.new,
      SetOrderCommand.new,
      GetOrderCommand.new,
      ForemanCommand.new,
      PlaceOrderGuest.new,
      RemoveGuestOrder.new,
      AddGuest.new,
      NextForeman.new,
      AddApprentice.new,
      RemoveApprentice.new
    ]
  end

  def parse(data)
    request = data[:user_message]

    for command in @commands
      if command.applies_to(request.downcase)
        command.prepare(data)
        return command
      end
    end

    ErrorCommand.new
  end
end
