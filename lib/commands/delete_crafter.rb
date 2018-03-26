require 'models/crafter'

module Commands
  class DeleteCrafter
    def applies_to(request)
      request.strip.downcase.start_with?("delete crafter")
    end

    def prepare(data)
      message = data[:user_message]
      @crafter_name = message.gsub("delete crafter", "").strip
    end

    def run
      crafter = Crafter.last(:user_name => @crafter_name)

      if crafter.destroy
        "#{@crafter_name} has been removed."
      end
    end
  end
end
