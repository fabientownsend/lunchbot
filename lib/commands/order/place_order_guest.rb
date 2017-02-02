require 'models/order'

class PlaceOrderGuest
  def applies_to(request)
    get_string_betwee_dash(request) && get_string_after_collon(request)
  end

  def prepare(data)
    @lunch_order = get_string_after_collon(data[:user_message])
    @name = get_string_betwee_dash(data[:user_message])
    @host_id = data[:user_id]
  end

  def run
    lunch_order = Order.last(:user_name => @name)

    if lunch_order
      update_order(lunch_order)
      "#{@name}'s order has been updated to #{@lunch_order}!"
    else
      place_new_order
      "#{@name}'s order for #{@lunch_order} has been placed!"
    end
  end

  private

  def update_order(lunch_order)
    lunch_order.lunch = @lunch_order
    lunch_order.save
  end

  def place_new_order
    new_order = Order.new(
      :user_name => @name.strip,
      :lunch => @lunch_order,
      :date => Time.now,
      :host => @host_id
    )
    new_order.save
  end

  def get_string_betwee_dash(message)
    message[/(?<=\-)(.+?)(?=\-)/]
  end

  def get_string_after_collon(message)
    message[/(?<=\:\s)(.+?)$/]
  end
end
