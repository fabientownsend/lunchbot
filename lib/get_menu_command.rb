class GetMenuCommand
  def initialize(menu)
    @menu = menu
  end

  def run()
    "The menu for this week is: #{@menu.url}"
  end
end
