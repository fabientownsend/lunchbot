require 'models/order'
require 'date'

class AddGuest
  def applies_to(request)
    request.start_with?("add guest:")
  end

  def prepare(data)
    @host_id = data[:user_id]
    message = data[:user_message]
    name = message.gsub("add guest:", "")
    @name = name.strip.downcase
  end

  def run
    guest_order = Order.last(:user_name => @name)

    return "#{@name} already exist" if !guest_exist?(guest_order)

    if @name.empty?
      "That is not a valid name."
    else
      add_guest
      "#{@name} has been added as a guest!"
    end
  end

  private

  def guest_exist?(guest)
    guest.nil?
  end

  def add_guest
    new_order = Order.new(
      :user_name => @name,
      :date => Date.today,
      :host => @host_id
    )
    new_order.save
  end
end
