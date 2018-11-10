require "models/apprentice"
require "models/user"

module Commands
  class AddApprentice
    def applies_to?(request)
      "add apprentice" == request[:user_message].strip.downcase
    end

    def prepare(data)
      @crafter = User.profile(data[:user_id])
    end

    def run
      if Apprentice.first(slack_id: @crafter.slack_id)
        "#{@crafter.user_name} is already in the database."
      else
        Apprentice.new(
          user_name: @crafter.user_name,
          slack_id: @crafter.slack_id,
          office: @crafter.office
        ).save

        "#{@crafter.user_name} has been added to apprentices."
      end
    end
  end
end
