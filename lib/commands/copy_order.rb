class CopyOrder
  def applies_to(request)
    request.start_with?("copy order: ")
  end

  def prepare(data)
    request = data[:user_message]
    @user_id = data[:user_id]
    @user_name = data[:user_name]
    find_user_to_copy = request.gsub("copy order: ", "")
    @user_to_copy = find_user_to_copy[/(?<=\<@)(\w+)(?=>)/]
  end

  def run
    order_to_copy = Order.last(:user_id => @user_to_copy)
    if order_to_copy
      place_order(order_to_copy.lunch)
      "#{@user_name} just copied <@#{@user_to_copy}>'s order!"
    else
      "That user does not have an order!"
    end
  end

  private

  def place_order(copied_lunch)
    existing_order = Order.last(:user_id => @user_id)
    if existing_order
      update(existing_order, copied_lunch)
    else
      place_new_order(copied_lunch)
    end
  end

  def update(order, lunch)
    order.lunch = lunch
    order.save
  end

  def place_new_order(lunch)
      order = Order.new(
        :user_id => @user_id,
        :user_name => @user_name,
        :lunch => lunch,
        :date => Time.now
      )
      order.save
  end
end
