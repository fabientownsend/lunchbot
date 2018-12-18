require 'days'
require 'models/user'
require 'models/apprentice'
require 'models/order'
require 'mark_all_out'

module Commands
  class Reminder
    def self.description
      "Remind people with no order | `remind`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request == "remind"
    end

    def prepare(data)
      @user_id = data[:user_id]
      @mark_all_out = data[:mark_all_out]

      @requester = User.profile(data[:user_id])
    end

    def run
      return "You are not the foreman!" if !Apprentice.foreman?(@user_id)

      @mark_all_out.update

      return "Everyone has an order." if people_to_remind.none?

      people_to_remind.join("\n").strip
    end

    private

    def people_to_remind
      users_to_remind + guests_to_remind
    end

    def users_to_remind
      Order.user_without_order(@requester.office).map do |user|
        "<@#{user.slack_id}>"
      end
    end

    def guests_to_remind
      Order.host_without_order(@requester.office).map do |guest|
        "#{guest.user_name} host: <@#{guest.host}>"
      end
    end
  end
end
