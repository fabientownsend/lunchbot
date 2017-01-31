class NextForeman
  def run
    shift_apprentice_table
  end

  def shift_apprentice_table
    @apprentice = Apprentice.first
    if @apprentice
      @apprentice.destroy
      "The new forman is <@#{Apprentice.first.user_name}>"
      readd_apprentice
    else
      "There are no apprentices!"
    end
  end

  def applies_to(request)
    request == "next foreman"
  end

  def prepare(data)
  end

  private

  def readd_apprentice
    user_name = @apprentice.user_name
    slack_id = @apprentice.slack_id
    new_apprentice = Apprentice.new(
      user_name: user_name,
      slack_id: slack_id
    )
  end
end
