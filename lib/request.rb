module SlackApi
  class Request
    def initialize(data)
      @data = data
    end

    def requires_answer?
      event_callback? && message? && !robot?
    end

    def valid_token?
      (ENV['SLACK_VERIFICATION_TOKEN'] == @data["token"])
    end

    def url_verification?
      @data["type"] == 'url_verification'
    end

    private

    def event_callback?
      @data["type"] == "event_callback"
    end

    def message?
      @data["event"]["type"] == "message"
    end

    def robot?
      !@data["event"]["bot_id"].nil?
    end
  end
end
