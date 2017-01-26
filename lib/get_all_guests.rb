require 'guest'

class GetAllGuests
  attr_reader :response

  def response?
    not response.nil?
  end

  def run()
    format_response(guests)
  end

  private

  def guests
    Guest.all.map { |guest| "#{guest.guest_name}" }
  end

  def format_response(guest)
    if guest.empty?
      @response = "no guest"
    else
      @response = guest.join("\n")
    end
  end
end
