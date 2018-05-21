require 'command_info'

module Commands
  class Help
    include CommandInfo

    def applies_to(request)
      request = request[:user_message].downcase
      request == "help" || request == "hello"
    end

    def prepare(data)
      @user_name = data[:user_name]
    end

    def run
      all_command_info
    end
  end
end
