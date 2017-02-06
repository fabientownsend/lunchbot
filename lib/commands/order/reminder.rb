require 'channel_info_provider'
require 'models/order'
require 'foreman_checker'
require 'days'

class Reminder
  include ForemanChecker

  def prepare(data)
    @channel_info = data[:channel_info]
    @channel_id = data[:channel_id]
    @team_id = data[:team_id]
    @user_id = data[:user_id]
    @members = @channel_info.members(@channel_id, @team_id)
  end

  def run
    if is_foreman(@user_id)
      format_response(not_ordered_members).strip
    else
      "You are not the foreman!"
    end
  end

  def applies_to(request)
    request == "remind" || request == "remind private"
  end

  private

  def format_response(orders)
    if orders.empty?
      "no orders"
    else
      orders.join("\n")
    end
  end

  def not_ordered_members
    crafter_wihtout_order + guest_without_order
  end

  def crafter_wihtout_order
    @members.map { |member_id| "<@#{member_id}>" if !has_ordered(member_id) }
  end

  def guest_without_order
    orders_current_week = Order.all(:date => Days.from_monday_to_friday)
    orders_current_week.map { |order|
      "#{order.user_name} host: <@#{order.host}>" if has_ordered?(order)
    }
  end

  private

  def has_ordered(user_id)
    Order.last(:user_id => user_id, :date => Days.from_monday_to_friday)
  end


  def has_ordered?(order)
    order.host && order.lunch.nil?
  end
end
