require 'commands/order/reminder'
require 'fake_channel_info_provider'

RSpec.describe Reminder do
  let (:data) {
    {
      user_message: "message",
      user_id: "user id",
      user_name: "user name",
      channel_id: "channel id",
      team_id: "team id",
      channel_info: FakeChannelInfoProvider.new
    }
  }
  before (:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: "user id"
    )
    foreman.save
  end

  it "return all the person that didn't order" do
    reminder = Reminder.new
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "doesn't remind people who placed an order" do
    Helper.order({user_id: "FabienUserId", user_name: "will", user_message: "burger"})

    reminder = Reminder.new
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@WillUserId>")
  end

  it "doesn't consider the order from the previous weeks" do
    Helper.order_previous_monday({
      user_id: "FabienUserId",
      user_name: "will",
      user_message: "burger"
    })

    reminder = Reminder.new
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "remind the guest's host if they don't have an order" do
    Helper.add_guest("jean gaston")
    reminder = Reminder.new
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>\njean gaston host: <@host id>")
  end

  it "doesn't remind guest form the previous weeks" do
    Helper.add_guest_previous_monday("jean gaston")
    reminder = Reminder.new
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end
end
