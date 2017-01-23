class SetMenuCommand
  attr_reader :user_message
  attr_reader :menu
  attr_reader :response

  def initialize(message, menu)
    @user_message = message
    @menu = menu
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

class GetMenuCommand
  attr_reader :response
  attr_reader :menu

  def initialize(menu)
    @menu = menu
  end
  
  def run()
    @response = "The menu for this week is: #{@menu.url}"
  end
end
