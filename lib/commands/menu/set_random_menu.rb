module Commands
  class SetRandomMenu
    def applies_to?(request)
      request = request[:user_message].downcase.strip
      request.include?("surprise menu")
    end
  end
end
