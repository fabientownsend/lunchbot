require "models/apprentice"

module Commands
  class GetForeman
    def applies_to?(request)
      "foreman" == request[:user_message].downcase.strip
    end

    def prepare(data)
      @requester = Crafter.profile(data[:user_id])
    end

    def run
      apprentice = Apprentice.foreman_for_office(@requester.office)

      if apprentice
        "The foreman for this week is #{apprentice.user_name}"
      else
        "There are no foreman!"
      end
    end
  end
end
