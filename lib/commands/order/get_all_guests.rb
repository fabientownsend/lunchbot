require 'models/order'

module Commands
  class GetAllGuests
    def run
      format_response(guests)
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request == "guests?"
    end

    def prepare(data)
    end

    private

    def guests
      guests = Order.all(:date => Days.from_monday_to_friday)
      guests.all.map { |order| order.user_name.to_s if order.host }.compact
    end

    def format_response(guest)
      if guest.empty?
        "no guest"
      else
        guest.join("\n")
      end
    end
  end
end
