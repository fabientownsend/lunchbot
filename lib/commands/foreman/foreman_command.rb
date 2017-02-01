require "models/apprentice"

class ForemanCommand
  def applies_to(request)
    request.start_with?("foreman")
  end

  def prepare(data)
  end

  def run()
    apprentice = Apprentice.first
    if apprentice
      "The foreman for this week is #{Apprentice.first.user_name}"
    else
      "There are no apprentices!"
    end
  end

  def applies_to(request)
    request.start_with?("foreman")
  end
end
