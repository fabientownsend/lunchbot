require 'models/user'
require 'models/menu'
require 'tiny_logger'

module Commands
  class GetMenu
    def self.description
      "Get this week's menu | `menu?`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.downcase.strip == "menu?"
    end

    def prepare(data)
      @user = User.profile(data[:user_id])
    end

    def run
      return if !@user

      if !@user.office
        return "You need to add your office. ex: \"office: london\""
      end

      if Menu.url_to_menu_for(@user.office)
        "The menu for this week is: #{Menu.url_to_menu_for(@user.office)}"
      else
        "The menu for this week is: no url provided"
      end
    end
  end
end
