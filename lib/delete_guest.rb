require 'guest'

class DeleteGuest
  attr_reader :response

  def initialize(guest_name)
    @guest_name = guest_name
  end

  def response?
    not response.nil?
  end

  def run()
    guest = Guest.last(:guest_name => @guest_name)
    if guest
      guest.destroy
      @response = "#{@guest_name} was deleted"
    else
      @response = "#{@guest_name} wasn't found"
    end
  end
end
