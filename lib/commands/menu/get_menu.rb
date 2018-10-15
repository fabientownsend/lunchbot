require 'models/crafter'
require 'models/menu'
require 'tiny_logger'

module Commands
  class GetMenu
    def applies_to(request)
      request = request[:user_message].downcase
      request.downcase.strip == "menu?"
    end

    def prepare(data)
      @crafter = Crafter.profile(data[:user_id])
    end

    def run
      return if !@crafter

      if !@crafter.office
        return "You need to add your office. ex: \"office: london\""
      end

      if Menu.selected_for(@crafter.office)
        "The menu for this week is: #{Menu.selected_for(@crafter.office)}"
      else
        "The menu for this week is: no url provided"
      end
    end
  end
end
