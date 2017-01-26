require 'guest'

class AddGuest
  attr_reader :response

  def initialize(guest_name, data)
    @guest_name = guest_name
    @host_id = data[:user_id]
  end

  def response?
    not response.nil?
  end

  def run()
    guest = Guest.last(:guest_name => @guest_name)

    if guest
      guest.host_id = @host_id
      guest.save
    else
      guest = Guest.new
      guest.attributes = {
        :guest_name => @guest_name,
        :host_id => @host_id
      }
      guest.save

      @response = "#{@guest_name} was added to the list of guest"
    end
  end
end
