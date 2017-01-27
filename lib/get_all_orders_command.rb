class GetAllOrdersCommand
  def run
    format_response(orders)
  end

  private

  def orders
    Order.all.map { |order| "#{order.user_name}: #{order.lunch}" }
  end

  def format_response(orders)
    response = ""
    if orders.empty?
      response = "no orders"
    else
      response = orders.join("\n")
    end

    response
  end
end
