require "apprentice"

class AddApprentice
  def run()
    apprentice = Apprentice.new(
    :user_name => @user_name,
    :slack_id => @user_id
    )
    apprentice.save
  end
  
  def applies_to(request)
    request == "add apprentice"
  end

  def prepare(data)
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end
end
