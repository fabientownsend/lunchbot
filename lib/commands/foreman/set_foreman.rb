require 'models/apprentice'

module Commands
  class SetForeman
    def self.description
      "Add yourself as the new foreman | `add apprentice`"
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.start_with? "set foreman:"
    end

    def prepare(data)
      request = data[:user_message]
      foreman = format_foreman(request)
      @foreman_id = foreman[/(?<=\<@)(\w+)(?=>)/]
      @requester = User.profile(data[:user_id])
    end

    def run
      person = Apprentice.profile(@foreman_id)
      if person && person.office == @requester.office
        Apprentice.set_as_foreman(@foreman_id, @requester.office)
        "<@#{@foreman_id}> is now the foreman!"
      else
        "That person is not an apprentice!"
      end
    end

    private

    def format_foreman(request)
      foreman = request.gsub("set foreman:", "")
      foreman[0] = "" if foreman[0] == " "
      foreman
    end
  end
end
