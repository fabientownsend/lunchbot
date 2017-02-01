require 'channel_info_provider'
require 'models/order'
require_relative '../../foreman_checker'

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
      format_response(not_ordered_members)
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
      not_ordered_members = []

      @members.each do |member_id|
        if !has_ordered(member_id)
          not_ordered_members << "<@#{member_id}>"
        end
      end

      not_ordered_members.sort
  end

  def has_ordered(user_id)
    Order.last(:user_id => user_id)
  end

  def guest_without_order
      not_ordered_members = []

      Order.each do |order|
        if order.host && order.lunch.nil?
            not_ordered_members << "#{order.user_name} host: <@#{order.host}>"
        end
      end

      not_ordered_members.sort
  end
end
