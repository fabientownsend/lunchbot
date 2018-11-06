require "models/apprentice"

module Commands
  class GetForeman
    def prepare(data) end

    def run
      apprentice = Apprentice.first
      if apprentice
        "The foreman for this week is #{Apprentice.first.user_name}"
      else
        "There are no foreman!"
      end
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.downcase.strip == "foreman"
    end
  end
end
