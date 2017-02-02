require 'models/apprentice'

class RemoveApprentice
  def run
    apprentice = Apprentice.last(:slack_id => @user_id)
    if apprentice.nil?
      "#{@user_name} is not an apprentice!"
    else
      apprentice.destroy
      "#{@user_name} has been removed from apprentices."
    end
  end

  def applies_to(request)
    request.downcase.strip == "remove apprentice"
  end

  def prepare(data)
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end
end
