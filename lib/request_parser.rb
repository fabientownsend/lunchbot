Dir["commands/*.rb"].each {|command_file| require command_file}

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
      RemoveApprentice.new,
      Out.new
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
