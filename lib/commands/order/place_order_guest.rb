require 'models/order'
require 'date'

class PlaceOrderGuest
  def applies_to(request)
    request.start_with?("order -") && get_string_between_dash(request)
  end

  def prepare(data)
    @lunch_order = get_string_after_collon(data[:user_message])
    @name = get_string_between_dash(data[:user_message])
    @host_id = data[:user_id]
    @date = data[:date] || Date.today
  end

  def run
    if @lunch_order
      place_order
    else
      "That is not a valid order."
    end
  end

  private

  def place_order
    existing_order = Order.last(
      :user_name => @name,
      :date => (Days.from_monday_to_friday)
    )

    if existing_order
      update_order(existing_order)
      "#{@name}'s order has been updated to #{@lunch_order}!"
    else
      place_new_order
      "#{@name}'s order for #{@lunch_order} has been placed!"
    end
  end

  def update_order(lunch_order)
    lunch_order.lunch = @lunch_order
    lunch_order.save
  end

  def place_new_order
    new_order = Order.new(
      :user_name => @name.strip,
      :lunch => @lunch_order,
      :date => @date,
      :host => @host_id
    )
    new_order.save
  end

  def get_string_between_dash(message)
    message[/(?<=\-)(.+?)(?=\-)/]
  end

  def get_string_after_collon(message)
    message[/(?<=\:\s)(.+?)$/]
  end
end
