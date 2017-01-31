class PlaceOrderGuest
  def initialize(lunch_order = nil, name = nil, host_id = nil)
    @lunch_order = lunch_order
    @name = name
    @host_id = host_id
  end

  def applies_to(request)
    get_string_betwee_dash(request) && get_string_after_collon(request)
  end

  def prepare(data)
    @lunch_order = get_string_after_collon(data[:user_message])
    @name = get_string_betwee_dash(data[:user_message])
    @host_id = data[:user_id]
  end

  def run
    lunch_order = Order.last(:user_name => @name)

    if lunch_order
      lunch_order.lunch = @lunch_order
      lunch_order.save
    else
      new_order = Order.new(
        :user_name => @name.strip,
        :lunch => @lunch_order,
        :date => Time.now,
        :host => @host_id
      )
      new_order.save
    end

    "#{@name} order saved"
  end

  private

  def get_string_betwee_dash(message)
    message[/(?<=\-)(.+?)(?=\-)/]
  end

  def get_string_after_collon(message)
    message[/(?<=\:\s)(.+?)$/]
  end
end
