require 'apprentice_rota'
require 'foreman_command'
require 'menu'
require 'menu_command'
require 'order'
require 'order_command'
require 'order_list'
require 'response'
require 'error_command'

class RequestParser
  def initialize()
    @menu = Menu.new
    @order_list = OrderList.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
  end

  def parse(data)
    request = data[:user_message]
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
      ErrorCommand.new
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
