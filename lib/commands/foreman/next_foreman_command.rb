require 'models/apprentice'

module Commands
  class NextForeman
    def run
      if shift_apprentice_table
        "The new foreman is <@#{Apprentice.first.slack_id}>"
      else
        "There are no apprentices!"
      end
    end

    def applies_to(request)
      request.downcase.strip == "next foreman"
    end

    def prepare(data) end

    private

    def shift_apprentice_table
      @apprentice = Apprentice.first
      return unless @apprentice
      @apprentice.destroy
      recreate(@apprentice)
    end

    def recreate(apprentice)
      new_apprentice = Apprentice.new(
        user_name: apprentice.user_name,
        slack_id: apprentice.slack_id
      )
      new_apprentice.save
    end
  end
end
