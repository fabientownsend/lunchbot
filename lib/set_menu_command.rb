class SetMenuCommand
  def initialize(menu)
    @menu = menu
  end

  def run()
    save_menu_url(@user_message)
    "<!here> Menu has been set: #{@menu.url}"
  end

  def applies_to(request)
    @user_message = request
    request.split.size == 3 &&
    request.include?("new menu") &&
    contain_url?(request)
  end

  private

  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end

  def contain_url?(request)
    request[/((http|https):\/\/)?(w{3}.)?[A-Za-z0-9-]+.(com|co.uk)/]
  end
end
