Dir["commands/foreman/*.rb"].each {|command_file| require command_file}
Dir["commands/menu/*.rb"].each {|command_file| require command_file}
Dir["commands/order/*.rb"].each {|command_file| require command_file}
Dir["commands/*.rb"].each {|command_file| require command_file}

class RequestParser
  def initialize()
    @commands = [
      AddApprentice.new,
      AddGuest.new,
      ForemanCommand.new,
      GetAllGuests.new,
      GetAllOrdersCommand.new,
      GetMenuCommand.new,
      GetOrderCommand.new,
      NextForeman.new,
      Out.new,
      PlaceOrderGuest.new,
      Reminder.new,
      RemoveApprentice.new,
      RemoveGuestOrder.new,
      SetMenuCommand.new,
      SetOrderCommand.new,
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
