require 'days'
require 'models/crafter'
require 'models/order'

class CustomerProvider
  def customers_without_order
    crafters_wihtout_order + guests_without_order
  end

  def everyone
    (crafters + guests).join("\n")
  end

  private

  def crafters_wihtout_order
    members = Crafter.all(:fields => [:slack_id])
    members.map { |member_id|
      "<@#{member_id.slack_id}>" if !has_ordered(member_id.slack_id)
    }.compact
  end

  def guests_without_order
    orders_current_week = Order.all(:date => Days.from_monday_to_friday)
    orders_current_week.map { |order|
      "#{order.user_name} host: <@#{order.host}>" if has_ordered?(order)
    }.compact
  end

  def has_ordered(user_id)
    Order.last(:user_id => user_id, :date => Days.from_monday_to_friday)
  end

  def has_ordered?(order)
    order.host && order.lunch.nil?
  end

  def crafters
    members = Crafter.all(:fields => [:slack_id])
    members.map { |member_id|  with_order(member_id.slack_id) }
  end

  def with_order(member_id)
    order = Order.last(
      :user_id => member_id,
      :date => Days.from_monday_to_friday
    )

    if order
      "<@#{member_id}>: #{order.lunch}"
    else
      "<@#{member_id}>"
    end
  end

  def guests
    guests_of_the_week.map { |guest| format(guest) }
  end

  def guests_of_the_week
    Order.all(
      :date => Days.from_monday_to_friday,
      :conditions => {:host.not => nil}
    ).compact
  end

  def format(guest)
    if guest.lunch
      "#{guest.user_name}: #{guest.lunch}"
    else
      guest.user_name.to_s
    end
  end
end
