module Commands
  class SetForeman
    def self.description
      "Set someone as the current foreman | `foreman: [@slack_username`]"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.start_with? "foreman:"
    end

    def prepare(data)
      request = data[:user_message]
      foreman = format_foreman(request)
      @foreman_id = foreman[/(?<=\<@)(\w+)(?=>)/]
      @requester = User.profile(data[:user_id])
    end

    def run
      user = User.profile(@foreman_id)
      return "User not found." if !user
      return "User must belong to the same office as you." if user.office != @requester.office

      User.set_as_foreman(@foreman_id, @requester.office)
      "<@#{@foreman_id}> is now the foreman!"
    end

    private

    def format_foreman(request)
      foreman = request.gsub("set foreman:", "")
      foreman[0] = "" if foreman[0] == " "
      foreman
    end
  end
end
