require 'apprentice_rota'
require 'error_command'
require 'foreman_command'
require 'menu'
require 'set_menu_command'
require 'get_menu_command'
require 'set_order_command'
require 'get_order_command'
require 'get_all_orders_command'
require 'reminder'
require 'place_order_guest'
require 'get_all_guests'

class RequestParser
  def initialize()
    @menu = Menu.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
    @commands = [SetMenuCommand.new(@menu), GetMenuCommand.new(@menu), Reminder.new, GetAllOrdersCommand.new, GetAllGuests.new, SetOrderCommand.new, GetOrderCommand.new, ForemanCommand.new(@apprentice_rota), PlaceOrderGuest.new]
  end

  def parse(data)
    request = data[:user_message]

    for command in @commands
      if command.applies_to(request)
        if command.kind_of? Reminder or command.kind_of? SetOrderCommand or command.kind_of? SetMenuCommand or command.kind_of? GetOrderCommand or command.kind_of? PlaceOrderGuest
          command.prepare(data) 
        end
        return command
      end
    end
    ErrorCommand.new
  end
end
