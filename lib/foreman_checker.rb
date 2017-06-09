module ForemanChecker
  def foreman?(slack_id)
    Apprentice.first && Apprentice.first.slack_id == slack_id
  end
end
