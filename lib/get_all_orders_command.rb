class GetAllOrdersCommand
  def run
    format_response(orders)
  end

  def applies_to(request)
    request == "all orders?"
  end

  def prepare(data)
  end

  private

  def orders
    Order.all.map { |order| "#{order.user_name}: #{order.lunch}" if !order.lunch.nil?}
  end

  def format_response(orders)
    response = ""
    if orders.empty?
      response = "no orders"
    else
      response = orders.join("\n").strip
    end

    response
  end
end
