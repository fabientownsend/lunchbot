require 'order'

class RemoveGuestOrder
  def initialize(name)
    @name = name.strip.downcase
  end

  def run
    order = Order.last(:user_name => @name)

    if order.nil?
      "#{@name} doesn't exist!"
    elsif !guest_order?(order)
      "#{@name} isn't a guest!"
    elsif order.destroy
      "#{@name} removed"
    else
      "error when deleting"
    end
  end

  private

  def guest_order?(order)
    order.host
  end
end
