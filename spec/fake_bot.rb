# typed: true
class FakeBot
  attr_reader :message
  attr_reader :user_id

  def send(message, user_id)
    @message = message
    @user_id = user_id
  end
end
