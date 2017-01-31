require 'apprentice_rota'
require 'error_command'
require 'foreman_command'
require 'set_menu_command'
require 'get_menu_command'
require 'set_order_command'
require 'get_order_command'
require 'get_all_orders_command'
require 'reminder'
require 'place_order_guest'
require 'get_all_guests'
require 'remove_guest_order'
require 'add_guest'
require 'next_foreman_command'
require 'apprentice'
require 'remove_apprentice'
require 'add_apprentice'

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
      if command.applies_to(request)
        command.prepare(data)
        return command
      end
    end

    ErrorCommand.new
  end
end
