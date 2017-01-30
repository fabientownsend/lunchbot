require 'channel_info_provider'
require 'order'

class Reminder
  def prepare(data)
    @channel_info = data[:channel_info]
    @channel_id = data[:channel_id]
    @team_id = data[:team_id]
    @members = @channel_info.members(@channel_id, @team_id)
  end

  def run
    format_response(not_ordered_members)
  end

  def applies_to(request)
    request == "remind"
  end

  def not_ordered_members
      not_ordered_members = []
      @members.each do |member_id|
        if !has_ordered(member_id)
          not_ordered_members << "<@#{member_id}>"
        end
      end
      not_ordered_members
  end

  def has_ordered(user_id)
    Order.last(:user_id => user_id)
  end

  def format_response(orders)
    response = ""
    if orders.empty?
      response = "no orders"
    else
      response = orders.join("\n")
    end

    response
  end
end
