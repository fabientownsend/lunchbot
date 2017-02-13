require "models/apprentice"

class GetForeman
  def prepare(data)
  end

  def run
    apprentice = Apprentice.first
    if apprentice
      "The foreman for this week is #{Apprentice.first.user_name}"
    else
      "There are no apprentices!"
    end
  end

  def applies_to(request)
    request.downcase.strip == "foreman"
  end
end
