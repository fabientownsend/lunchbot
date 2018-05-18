require 'models/order'
require 'date'
require 'days'

module Commands
  class AddGuest
    def applies_to(request)
      request = request[:user_message].downcase
      request.start_with?("add guest:")
    end

    def prepare(data)
      @host_id = data[:user_id]
      message = data[:user_message]
      name = message.gsub("add guest:", "")
      @name = name.strip.downcase
      @date = data[:date] || Date.today
    end

    def run
      guest_order = Order.last(
        user_name: @name,
        date: Days.from_monday_to_friday
      )
      return "#{@name} already exist" unless guest_exist?(guest_order)
      return "That is not a valid name." if @name.empty?
      add_guest
      "#{@name} has been added as a guest!"
    end

    private

    def guest_exist?(guest)
      guest.nil?
    end

    def add_guest
      new_order = Order.new(
        user_name: @name,
        date: @date,
        host: @host_id
      )
      new_order.save
    end
  end
end
