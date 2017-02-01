module ForemanChecker
  def is_foreman(slack_id)
    Apprentice.first and Apprentice.first.slack_id == slack_id
  end
end
