require 'models/menu'

module Commands
  class GetMenu
    def run
      if Menu.last
        "The menu for this week is: #{Menu.last.url}"
      else
        "The menu for this week is: no url provided"
      end
    end

    def prepare(data) end

    def applies_to(request)
      request = request[:user_message].downcase
      request.downcase.strip == "menu?"
    end
  end
end
