class Order
  attr_reader :user_name
  attr_reader :lunch_order
  attr_reader :user_id

  def initialize(user_name, lunch_order, user_id)
    @user_name = user_name
    @lunch_order = lunch_order
    @user_id = user_id
  end
end
