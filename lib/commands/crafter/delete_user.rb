require 'models/user'

module Commands
  class DeleteUser
    def self.description
      "Delete a user | `delete user: [@slack_username]`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("delete user")
    end

    def prepare(data)
      message = data[:user_message]
      @user_name = message.gsub("delete user:", "").strip
    end

    def run
      user = User.last(:user_name => @user_name)

      if user.destroy
        "#{@user_name} has been removed."
      end
    end
  end
end
