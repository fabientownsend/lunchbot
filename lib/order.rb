class Order
  attr_reader :user_name
  attr_reader :lunch
  attr_reader :user_id

  def initialize(user_name, lunch, user_id)
    @user_name = user_name
    @lunch = lunch
    @user_id = user_id
  end
end
