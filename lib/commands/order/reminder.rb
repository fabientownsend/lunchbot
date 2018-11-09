require 'days'
require 'models/crafter'
require 'models/apprentice'
require 'models/order'
require 'mark_all_out'

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

      crafters_to_remind = Order.crafter_without_order(@requester.office).map do |crafter|
        "<@#{crafter.slack_id}>"
      end

      guest_to_remind = Order.host_without_order(@requester.office).map do |guest|
        "#{guest.user_name} host: <@#{guest.host}>"
      end

      if crafters_to_remind.empty? && guest_to_remind.empty?
        return "Everyone has an order."
      end

      (crafters_to_remind + guest_to_remind).join("\n").strip
    end
  end
end
