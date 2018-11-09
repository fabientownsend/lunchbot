require 'days'
require 'models/crafter'
require 'models/apprentice'
require 'models/order'
require 'mark_all_out'
require 'commands/order/customer_provider'

module Commands
  class Reminder
    def applies_to?(request)
      request = request[:user_message].downcase
      request == "remind"
    end

    def prepare(data)
      @user_id = data[:user_id]
      @mark_all_out = data[:mark_all_out]

      @requester = Crafter.profile(data[:user_id])
    end

    def run
      return "You are not the foreman!" if !Apprentice.foreman?(@user_id)

      @mark_all_out.update

      c = Order.have_not_ordered(@requester.office).map { |a| "<@#{a.slack_id}>" }
      g = Order.host_without_order(@requester.office).map do |o|
        "#{o.user_name} host: <@#{o.host}>"
      end

      if c.empty? && g.empty?
        return "Everyone has an order."
      end

      (c + g).join("\n").strip
    end
  end
end
