require 'models/menu'
require 'foreman_checker'

module Commands
  class SetMenu
    include ForemanChecker

    def prepare(data)
      @user_message = data[:user_message]
      @user_id = data[:user_id]
    end

    def run
      if is_foreman(@user_id)
        update_url
      else
        "You are not the foreman!"
      end
    end

    def applies_to(request)
      request = request.downcase.strip
      request.split.size == 3 && request.include?("new menu")
    end

    private

    def update_url
      if extract_url(@user_message)
        save_url(extract_url(@user_message))
        "<!here> Menu has been set: #{extract_url(@user_message)}"
      else
        "That is not a valid URL!"
      end
    end

    def extract_url(request)
      protocol = "((http|https):\/\/)?(w{3}.)"
      subdomain = "[A-Za-z0-9-]+."
      domain = "[A-Za-z0-9-]+.(com|co.uk)"
      path = "([a-zA-Z0-9_\.\/\-]+)"
      request[/#{protocol}?#{subdomain}?#{domain}#{path}?/]
    end

    def save_url(url)
      menu = Menu.new(
        url: url,
        date: Time.now
      )
      menu.save
    end
  end
end
