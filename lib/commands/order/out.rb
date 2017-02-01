require 'models/order'

class Out
  def applies_to(request)
    request == "out"
  end

  def prepare(data)
    @user_id = data[:user_id]
    @user_name = data[:user_name]
  end

  def run
    mark_out = Order.new(
      :user_id => @user_id,
      :user_name => @user_name,
      :lunch => "out",
      :date => Time.now
    )
    mark_out.save
  end
end
