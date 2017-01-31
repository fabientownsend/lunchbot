class NextForeman
  def run
    shift_apprentice_table
  end

  def shift_apprentice_table
    apprentice = Apprentice.first
    user_name = apprentice.user_name
    slack_id = apprentice.slack_id
    if apprentice
      apprentice.destroy
      "The new forman is <@#{Apprentice.first.user_name}>"
      new_apprentice = Apprentice.new(
        user_name: user_name,
        slack_id: slack_id
      )
    else
      "There are no apprentices!"
    end
  end

  def applies_to(request)
    request == "next foreman"
  end

  def prepare(data)
  end
end
