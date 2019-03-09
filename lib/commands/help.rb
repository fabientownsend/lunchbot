module Commands
  class Help
    def self.description
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request == "help"
    end

    def prepare(data)
      @user_name = data[:user_name]
    end

    def run
      <<~HEREDOC
        #{report_issues}
        #{join_the_channel}

        #{command_descriptions}
      HEREDOC
    end

    private

    def command_descriptions
      load_commands
      commands.
        map(&:description).
        compact.
        sort.
        join("\n")
    end

    def commands
      Commands.constants.map do |command|
        Object.const_get("Commands::#{command}")
      end
    end

    def load_commands
      command_files.each { |file| require file }
    end

    def command_files
      Dir["#{File.dirname(__FILE__)}/commands/**/*.rb"]
    end

    def report_issues
      <<~HEREDOC
        :bug: Want to report a bug or have an idea for a new feature? :package:
        Share it here: :loudspeaker: <https://github.com/fabientownsend/lunchbot/issues/new> :loudspeaker:
      HEREDOC
    end

    def join_the_channel
      "Join the channel #lunchbot_dev"
    end
  end
end
