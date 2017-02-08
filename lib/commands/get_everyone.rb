require 'models/order'
require 'days'

class GetEveryone
  def applies_to(request)
    request.strip.downcase == "everyone"
  end

  def prepare(data)
    @user_id = data[:user_id]
  end

  def run
    (crafters + guests).join("\n")
  end

  private

  def crafters
    members = Crafter.all(:fields => [:slack_id])
    members.map { |member_id|  with_order(member_id.slack_id) }
  end

  def with_order(member_id)
    order = Order.last(
      :user_id => member_id,
      :date => Days.from_monday_to_friday
    )

    if order
      "<@#{member_id}>: #{order.lunch}"
    else
      "<@#{member_id}>"
    end
  end

  def guests
    guests_of_the_week.map { |guest| format(guest) }
  end

  def guests_of_the_week
    Order.all(
      :date => Days.from_monday_to_friday,
      :conditions => {:host.not => nil}
    ).compact
  end

  def format(guest)
    if guest.lunch
      "#{guest.user_name}: #{guest.lunch}"
    else
      "#{guest.user_name}"
    end
  end
end
