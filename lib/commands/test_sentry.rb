require 'feature_flag'

module Commands
  class TestSentry < FeatureFlag
    release_for 'Andrew MacMurray'

    def applies_to(request)
      request[:user_message].downcase == "sentry test"
    end

    def prepare(data)
      @tester = data[:user_name]
    end

    def run
      if feature_access?(@tester)
        begin
          1 / 0
        rescue ZeroDivisionError => exception
          Logger.info "Trace 1"
          Raven.capture_exception(exception)
        end
      end
    end
  end
end
