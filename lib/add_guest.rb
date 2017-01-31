require 'order'

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

    guest = add_guest

    if guest.save
      "#{@name} added"
    else
      "error occured"
    end
  end

  private

  def guest_exist?(guest)
    guest.nil?
  end

  def add_guest
    new_order = Order.new(
      :user_name => @name,
      :date => Time.now,
      :host => @host_id
    )
    new_order
  end
end
