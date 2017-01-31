require 'menu'

class SetMenuCommand
  def prepare(data)
    @user_message = data[:user_message]
  end

  def run()
    set_url(extract_url(@user_message))
    "<!here> Menu has been set: #{extract_url(@user_message)}"
  end

  def applies_to(request)
    request.split.size == 3 &&
    request.include?("new menu") &&
    extract_url(request)
  end

  private

  def extract_url(request)
    request[/((http|https):\/\/)?(w{3}.)?[A-Za-z0-9-]+.(com|co.uk)([a-zA-Z0-9\.\/\-]+)?/]
  end

  def set_url(url)
    menu = Menu.new(
      :url => url,
      :date => Time.now
    )
    menu.save
  end
end
