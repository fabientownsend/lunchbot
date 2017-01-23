require_relative 'menu'

class MenuCommand
  attr_reader :user_message
  attr_reader :menu
  attr_reader :response

  def initialize(message)
    @user_message = message
    @menu = Menu.new
  end
  
  def run()
    save_menu_url(user_message)
    @response = "<!here> Menu has been set :#{@menu.url}"
  end
  
  private 

  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end
end
