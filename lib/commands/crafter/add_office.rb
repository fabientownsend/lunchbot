require 'feature_flag'
require 'models/crafter'
require 'models/office'

module Commands
  class AddOffice < FeatureFlag
    release_for 'Fabien Townsend'

    def applies_to(request)
      if feature_access?(request[:user_name])
        request = request[:user_message].downcase
        request.strip.downcase.start_with?("office:")
      end
    end

    def prepare(data)
      @office = data[:user_message].gsub("office:", "").strip.downcase
      @slack_id = data[:user_id]
    end

    def run
      if Office.available?(@office)
        Crafter.profile(@slack_id).add_office(@office)
        "You were added to the #{@office}"
      else
        "The office available are: #{Office.list.map(&:capitalize).join(", ")}"
      end
    end
  end
end
