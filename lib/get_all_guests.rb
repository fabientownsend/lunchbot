require 'guest'

class GetAllGuests
  def run()
    format_response(guests)
  end

  private

  def guests
    Guest.all.map { |guest| "#{guest.guest_name}" }
  end

  def format_response(guest)
    if guest.empty?
      "no guest"
    else
      guest.join("\n")
    end
  end
end
