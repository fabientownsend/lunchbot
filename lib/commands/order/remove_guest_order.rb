require 'models/order'

class RemoveGuestOrder
  def applies_to(request)
    request.start_with?("remove guest:")
  end

  def prepare(data)
    message = data[:user_message]
    name = message.gsub("remove guest:", "")
    @name = name.strip.downcase
  end

  def run
    order = Order.last(:user_name => @name)

    if order.nil? or !guest_order?(order)
      "There is no such guest!"
    elsif order.destroy
      "#{@name} has been removed."
    else
      "Error when deleting!"
    end
  end

  private

  def guest_order?(order)
    order.host
  end
end
