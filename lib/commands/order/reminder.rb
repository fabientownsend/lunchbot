require 'days'
require 'foreman_checker'
require 'models/crafter'
require 'models/order'
require 'mark_all_out'
require 'commands/order/customer_provider'

class Reminder
  include ForemanChecker

  def prepare(data)
    @channel_id = data[:channel_id]
    @team_id = data[:team_id]
    @user_id = data[:user_id]
    @mark_all_out = data[:mark_all_out]
  end

  def run
    if is_foreman(@user_id)
      @mark_all_out.update
      format_response(not_ordered_members).strip
    else
      "You are not the foreman!"
    end
  end

  def applies_to(request)
    request == "remind"
  end

  private

  def format_response(orders)
    if orders.empty?
      "Everyone has an order."
    else
      orders.join("\n")
    end
  end

  def not_ordered_members
    CustomerProvider.new().customers_without_order
  end
end
