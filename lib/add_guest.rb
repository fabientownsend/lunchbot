require 'order'

class AddGuest
  def initialize(name, host_id)
    @name = name.strip.downcase
    @host_id = host_id
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
