require_relative 'menu_command'
require_relative 'menu'

class RequestParser
  def intialize()
    @menu = Menu.new
    @order_list = OrderList.new
  end

  def parse(request)
    if menu_request?(request)
      SetMenuCommand.new(request, @menu)
    elsif request == "menu?"
      GetMenuCommand.new(@menu)
    elsif set_order_request?(request)
      SetOrderCommand.new(request, @order_list)
    elsif request.start_with?("order:") && request.split.size > 1
      "get_order"
    elsif request.start_with?("foreman")
      "foreman"
    else
      "error"
    end
  end

  private

  def menu_request?(request)
    request.split.size == 3 &&
    request.include?("new menu") &&
    contain_url?(request)
  end

  def contain_url?(request)
    request[/((http|https):\/\/)?(w{3}.)?[A-Za-z0-9-]+.(com|co.uk)/]
  end

  def set_order_request?(request)
    request.start_with?("order me: ") && request.split.size > 2
  end
end
