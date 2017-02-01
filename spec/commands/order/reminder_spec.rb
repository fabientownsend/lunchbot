require 'commands/order/reminder'
require 'fake_channel_info_provider'
require 'spec_helper'

RSpec.describe Reminder do
  before (:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: "user id"
    )
    foreman.save
  end

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
