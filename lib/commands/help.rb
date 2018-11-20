module Commands
  class Help
    def self.description
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request == "help" || request == "hello"
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
      commands.
        map(&:description).
        compact.
        sort.
        join("\n")
    end

    def commands
      Dir.glob("lib/commands/**/*.rb").
        map { |path| File.basename(path).gsub(".rb", "") }.
        map { |file_name| file_name.split("_").map { |slice| slice.capitalize }.join }.
        map { |class_name| "Commands::#{class_name}" }.
        map { |full_class_name| Object.const_get(full_class_name) }
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
