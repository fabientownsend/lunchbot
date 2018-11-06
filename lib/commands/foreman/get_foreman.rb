require "models/apprentice"

module Commands
  class GetForeman
    def applies_to?(request)
      "foreman" == request[:user_message].downcase.strip
    end

    def prepare(data)
      @crafter = Crafter.profile(data[:user_id])
    end

    def run
      apprentice = Apprentice.first
      if apprentice
        "The foreman for this week is #{Apprentice.first.user_name}"
      else
        "There are no foreman!"
      end
    end
  end
end
