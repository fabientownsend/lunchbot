require 'apprentice_rota'
require 'error_command'
require 'foreman_command'
require 'menu'
require 'set_menu_command'
require 'get_menu_command'
require 'set_order_command'
require 'get_order_command'
require 'get_all_orders_command'

class RequestParser
  def initialize()
    @menu = Menu.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
  end

  def parse(data)
    request = data[:user_message]
    if menu_request?(request)
      SetMenuCommand.new(request, @menu)
    elsif request == "menu?"
      GetMenuCommand.new(@menu)
    elsif request == "all orders?"
      GetAllOrdersCommand.new
    elsif set_order_request?(request)
      lunch = request.gsub("order me: ", "")
      SetOrderCommand.new(lunch, data)
    elsif request.start_with?("order:") && request.split.size > 1
      GetOrderCommand.new(request)
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
