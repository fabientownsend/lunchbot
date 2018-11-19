require 'models/user'

module Commands
  class DeleteUser
    def self.description
      "Delete a crafter | `delete crafter slack_user_name`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("delete crafter")
    end

    def prepare(data)
      message = data[:user_message]
      @crafter_name = message.gsub("delete crafter", "").strip
    end

    def run
      crafter = User.last(:user_name => @crafter_name)

      if crafter.destroy
        "#{@crafter_name} has been removed."
      end
    end
  end
end
