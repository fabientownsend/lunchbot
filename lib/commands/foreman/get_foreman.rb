module Commands
  class GetForeman
    def self.description
      "Show this week's foreman | `foreman?`"
    end

    def applies_to?(request)
      "foreman?" == request[:user_message].downcase.strip
    end

    def prepare(data)
      @requester = User.profile(data[:user_id])
    end

    def run
      foreman = User.foreman_for_office(@requester.office)
      return "There is no foreman!" if !foreman
      "The foreman for this week is #{foreman.user_name}"
    end
  end
end
