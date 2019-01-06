require 'models/menu'

module Commands
  class SetMenu
    KIN_URL = "kin.orderswift.com".freeze

    def self.description
      "Set a menu | `menu: www.menu-url.com`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request = request.downcase.strip
      request.include?("menu:")
    end

    def prepare(data)
      @user_message = data[:user_message]
      @user = User.profile(data[:user_id])
    end

    def run
      return "You need to add your office. ex: \"office: london\"" unless @user.office
      return "You are not the foreman!" unless foreman?(@user)

      menu_url = extract_url(@user_message)

      return "That is not a valid URL!" if !menu_url

      save_menu(menu_url)
      respond(menu_url)
    end

    private

    def foreman?(user)
      User.foreman?(user.slack_id)
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
      Menu.new(url: url, date: Time.now, office: @user.office).save
    end

    def kin?(url)
      url.include?(KIN_URL)
    end
  end
end
