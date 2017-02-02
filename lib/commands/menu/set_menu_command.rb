require 'models/menu'
require 'foreman_checker'

class SetMenuCommand
  include ForemanChecker

  def prepare(data)
    @user_message = data[:user_message]
    @user_id = data[:user_id]
  end

  def run()
    if is_foreman(@user_id)
      update_url
    else
      "You are not the foreman!"
    end
  end

  def applies_to(request)
    request = request.downcase.strip
    extract_url(request) &&
    request.split.size == 3 &&
    request.include?("new menu")
  end

  private

  def update_url
    set_url(extract_url(@user_message))
    "<!here> Menu has been set: #{extract_url(@user_message)}"
  end

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
