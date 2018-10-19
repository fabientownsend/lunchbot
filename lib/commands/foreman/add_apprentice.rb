require "models/apprentice"

module Commands
  class AddApprentice
    def run
      if Apprentice.first(slack_id: @user_id)
        "#{@user_name} is already in the database."
      else
        apprentice = Apprentice.new(
          user_name: @user_name,
          slack_id: @user_id
        )
        apprentice.save
        "#{@user_name} has been added to apprentices."
      end
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.strip.downcase == "add apprentice"
    end

    def prepare(data)
      @user_id = data[:user_id]
      @user_name = data[:user_name]
    end
  end
end
