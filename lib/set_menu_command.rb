class SetMenuCommand
  def initialize(message, menu)
    @user_message = message
    @menu = menu
  end

  def run()
    save_menu_url(@user_message)
    "<!here> Menu has been set: #{@menu.url}"
  end

  private

  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end
end
