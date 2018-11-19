require 'feature_flag'

module Commands
  class TestSentry < FeatureFlag
    release_for 'FabieN Townsend'

    def self.description
      # not implemented
    end

    def applies_to?(request)
      request[:user_message].downcase == "sentry test"
    end

    def prepare(data)
      @tester = data[:user_name]
    end

    def run
      if feature_access?(@tester)
        "Hello"
      end
    end
  end
end
