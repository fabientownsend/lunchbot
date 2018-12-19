require 'models/menu'
require 'models/apprentice'

module Commands
  class SetMenu
    KIN_URL = "kin.orderswift.com".freeze

    def self.description
      "Set a menu | `new menu www.menu-url.com`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request = request.downcase.strip
      request.split.size == 3 && request.include?("new menu")
    end

    def prepare(data)
      @user_message = data[:user_message]
      @apprentice = Apprentice.profile(data[:user_id])
    end

    def run
      return "You need to add your office. ex: \"office: london\"" unless @apprentice.office
      return "You are not the foreman!" unless foreman?(@apprentice)

      menu_url = extract_url(@user_message)

      return "That is not a valid URL!" if !menu_url

      save_menu(menu_url)
      respond(menu_url)
    end

    private

    def foreman?(apprentice)
      Apprentice.foreman?(apprentice.slack_id)
    end

    def respond(menu_url)
      if kin?(menu_url)
        "Kin again?! :eye-roll: fine ... <!here> Menu has been set: #{menu_url}"
      else
        "<!here> Menu has been set: #{menu_url}"
      end
    end

    def extract_url(request)
      protocol = "((http|https):\/\/)?(w{3}.)"
      subdomain = "[A-Za-z0-9-]+."
      domain = "[A-Za-z0-9-]+.(com|co.uk)"
      path = "([a-zA-Z0-9'_\.\/\-]+)"
      request[/#{protocol}?#{subdomain}?#{domain}#{path}?/]
    end

    def save_menu(url)
      Menu.new(url: url, date: Time.now, office: @apprentice.office).save
    end

    def kin?(url)
      url.include?(KIN_URL)
    end
  end
end
