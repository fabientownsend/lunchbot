require 'order'

class GetAllGuests
  def run()
    format_response(guests)
  end

  def applies_to(request)
    request == "guests?"
  end

  def prepare(data)
  end

  private

  def guests
    Order.all.map { |order| "#{order.user_name}" if order.host }.compact
  end

  def format_response(guest)
    if guest.empty?
      "no guest"
    else
      guest.join("\n")
    end
  end
end
