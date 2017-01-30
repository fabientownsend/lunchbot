class PlaceOrderGuest
  def prepare(data)
    @user_message = data[:user_message]
    @host_id = data[:user_id]
    @lunch_order = string_after_collon(@user_message)
    @name = string_between_dash(@user_message)
  end

  def run
    lunch_order = Order.last(:user_name => @name)

    if lunch_order
      lunch_order.lunch = @lunch_order
      lunch_order.save
    else
      new_order = Order.new(
      :user_name => @name,
      :lunch => @lunch_order,
      :date => Time.now,
      :host => @host_id
      )
      new_order.save
    end

    "#{@name} order saved"
  end

  def applies_to(request)
    string_between_dash(request) && string_after_collon(request)
  end

  private

  def string_between_dash(message)
    message[/(?<=\-)(.+?)(?=\-)/]
  end

  def string_after_collon(message)
    message[/(?<=\:\s)(.+?)$/]
  end
end
