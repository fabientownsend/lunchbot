require 'commands/reminder'
require 'fake_channel_info_provider'

RSpec.describe Reminder do

  it "return all the person that didn't order" do
    data = {
      user_message: "message",
      user_id: "user id",
      user_name: "user name",
      channel_id: "channel id",
      team_id: "team id",
      channel_info: FakeChannelInfoProvider.new
    }
    reminder = Reminder.new()
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end
end
