require 'models/user'
require 'models/menu'
require 'tiny_logger'

module Commands
  class GetMenu
    def self.description
      "To get this week's menu | `menu?`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.downcase.strip == "menu?"
    end

    def prepare(data)
      @crafter = User.profile(data[:user_id])
    end

    def run
      return if !@crafter

      if !@crafter.office
        return "You need to add your office. ex: \"office: london\""
      end

      if Menu.url_to_menu_for(@crafter.office)
        "The menu for this week is: #{Menu.url_to_menu_for(@crafter.office)}"
      else
        "The menu for this week is: no url provided"
      end
    end
  end
end
