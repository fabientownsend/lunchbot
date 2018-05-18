require 'command_info'
require 'tiny_logger'
require 'feature_flag'

module Commands
  class Help < FeatureFlag
    release_for 'FabieN Townsend'
    include CommandInfo

    def applies_to(request)
      request = request[:user_message].downcase
      request == "help" || request == "hello"
    end

    def prepare(data)
      @user_name = data[:user_name]
    end

    def run
      if feature_access?(@user_name)
        'lol'
      else
        all_command_info
      end
    end
  end
end
