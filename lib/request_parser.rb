require_relative 'menu'
require_relative 'response'
require_relative 'order_list'
require_relative 'order'
require_relative 'apprentice_rota'
require_relative 'order_command'
require_relative 'menu_command'
require_relative 'foreman_command'

class RequestParser
  def initialize()
    @menu = Menu.new
    @order_list = OrderList.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
  end

  def parse(data)
    request = data['text']
    if menu_request?(request)
      SetMenuCommand.new(request, @menu)
    elsif request == "menu?"
      GetMenuCommand.new(@menu)
    elsif set_order_request?(request)
      SetOrderCommand.new(request, @order_list, data)
    elsif request.start_with?("order:") && request.split.size > 1
      GetOrderCommand.new(request, @order_list)
    elsif request.start_with?("foreman")
      ForemanCommand.new(@apprentice_rota)
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
