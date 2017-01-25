class GetMenuCommand
  attr_reader :response

  def initialize(menu)
    @menu = menu
  end

  def response?
    response
  end

  def run()
    @response = "The menu for this week is: #{@menu.url}"
  end
end
