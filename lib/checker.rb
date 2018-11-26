module SlackApi
  class Checker
    def initialize(data)
      @data = data
    end

    def require_answer?
      event_callback? && message? && !robot?
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
