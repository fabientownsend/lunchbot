require 'models/order'
require 'date'

class Out
  def applies_to(request)
    request == "out"
  end

  def prepare(data)
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end

  def run
    mark_out
  end

  private

  def mark_out
    existing_order = Order.last(
      :user_id => @user_id,
      :date => Days.from_monday_to_friday
    )
    if existing_order
      update(existing_order)
    else
      create_new_order
    end
    "You have been marked out!"
  end

  def update(order)
    order.lunch = "out"
    order.save
  end

  def create_new_order
    mark_out = Order.new(
      :user_id => @user_id,
      :user_name => @user_name,
      :lunch => "out",
      :date => Date.today
    )
    mark_out.save
  end
end
