Dir["#{File.dirname(__FILE__)}/commands/**/*.rb"].each {|file| require file }

class RequestParser
  def initialize()
    @commands = [
      AddApprentice.new,
      AddGuest.new,
      GetForeman.new,
      GetAllGuests.new,
      GetAllOrders.new,
      GetMenu.new,
      GetOrderCommand.new,
      NextForeman.new,
      Out.new,
      PlaceOrderGuest.new,
      Reminder.new,
      RemoveApprentice.new,
      RemoveGuestOrder.new,
      SetMenu.new,
      PlaceOrder.new,
      Help.new,
      CopyOrder.new,
      Ping.new,
      SetForeman.new,
      AllFoodOrders.new
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
  end
end
