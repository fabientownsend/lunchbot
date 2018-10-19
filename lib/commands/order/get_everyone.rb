require 'models/order'
require 'days'
require 'commands/order/customer_provider'

module Commands
  class GetEveryone
    def applies_to?(request)
      request = request[:user_message].downcase
      request.strip.downcase == "everyone"
    end

    def prepare(data)
      @user_id = data[:user_id]
    end

    def run
      CustomerProvider.new.everyone
    end
  end
end
