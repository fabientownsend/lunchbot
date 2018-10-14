require 'feature_flag'
require 'models/crafter'
require 'models/menu'
require 'tiny_logger'

module Commands
  class GetMenu < FeatureFlag
    release_for 'Fabien Townsend'

    def applies_to(request)
      request = request[:user_message].downcase
      request.downcase.strip == "menu?"
    end

    def prepare(data)
      @crafter = Crafter.profile(data[:user_id])
    end

    def run
      Logger.info("Trace #{@crafter.user_name}")
      Logger.info("Trace #{@crafter.office}")
      if feature_access?(@crafter.user_name) && !@crafter.office
        return "You need to add your office. ex: \"office: london\""
      end

      if Menu.selected_for(@crafter.office)
        "The menu for this week is: #{Menu.selected_for(@crafter.office)}"
      elsif Menu.last
        "The menu for this week is: #{Menu.last.url}"
      else
        "The menu for this week is: no url provided"
      end
    end
  end
end
