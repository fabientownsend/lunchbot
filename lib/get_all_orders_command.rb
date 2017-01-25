class GetAllOrdersCommand
  attr_reader :response

  def run
    format_response(orders)
  end

  def response?
    response
  end

  private

  def orders
    Order.all.map { |order| "#{order.user_name}: #{order.lunch}" }
  end

  def format_response(orders)
    if orders.empty?
      @response = "no orders"
    else
      @response = orders.join("\n")
    end
  end
end
