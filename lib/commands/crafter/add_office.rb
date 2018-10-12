require 'feature_flag'
require 'models/crafter'

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
      @office = data[:user_message].gsub("office:", "").strip
      @slack_id = data[:user_id]
    end

    def run
      crafter = Crafter.last(:slack_id => @slack_id)
      crafter.office = @office
      crafter.save
      crafter.office
    end
  end
end
