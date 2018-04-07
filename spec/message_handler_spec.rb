require 'commands/foreman/add_apprentice'
require 'commands/help'
require 'commands/order/add_guest'
require 'days'
require 'fake_mark_all_out'
require 'fake_response'
require 'fake_user_info_provider'
require 'message_handler'

RSpec.describe MessageHandler do
  let(:fake_response) { FakeResponse.new }
  let(:fake_mark_all_out) { FakeMarkAllOut.new }
  let(:fake_user_info_provider) { FakeUserInfoProvider.new }
  let(:team_id) { "T026MULUJ" }
  let(:recipient) { "D3S6XE6SZ" }
  let(:channel_id) { "CHANNELID" }

  let(:message_handler) do
    MessageHandler.new(
      mark_all_out: fake_mark_all_out,
      response: fake_response,
      user_info_provider: fake_user_info_provider
    )
  end

  before(:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: recipient
    )
    foreman.save
    allow(Date).to receive(:today).and_return Days.monday
  end

  include CommandInfo

  it "return all commands info when request is for help" do
    message_from_slack(user_message: "help")

    expect(fake_response.message).to eq(all_command_info)
  end

  it "returns a message for a new menu" do
    message_from_slack(user_message: "new menu: <http://www.test.com|www.test.com>")

    bot_response = "<!here> Menu has been set: http://www.test.com"
    expect(fake_response.message).to eq(bot_response)
    expect(fake_response.user_id).to eq(channel_id)
  end

  it "says that the url is invalid if the url is invalid" do
    message_from_slack(user_message: "new menu: invalid")
    expect(fake_response.message).to eq("That is not a valid URL!")
  end

  it "returns the url when you ask the menu which is not provided" do
    message_from_slack(user_message: "menu?")

    bot_response = "The menu for this week is: no url provided"
    expect(fake_response.message).to eq(bot_response)
  end

  it "return the url when you ask the menu which is not provided" do
    message_from_slack(user_message: "new menu: <http://www.test.com|www.test.com>")
    message_from_slack(user_message: "menu?")

    bot_response = "The menu for this week is: http://www.test.com"
    expect(fake_response.message).to eq(bot_response)
    expect(fake_response.user_id).to eq(channel_id)
  end

  it "responds with the order you just placed" do
    message_from_slack(user_message: "order: hamburger")

    expect(fake_response.message).to eq("Will just ordered `hamburger`.")
    expect(fake_response.user_id).to eq(channel_id)
  end

  it "tells you if your order is invalid" do
    message_from_slack(user_message: "order:")
    expect(fake_response.message).to eq("That is not a valid order.")
  end

  it "return the foreman of the week" do
    add_apprentice = Commands::AddApprentice.new
    add_apprentice.prepare(user_name: "Will", slack_id: "id")
    add_apprentice.run

    message_from_slack(user_message: "foreman")

    expect(fake_response.message).to eq("The foreman for this week is Will")
    expect(fake_response.user_id).to eq(channel_id)
  end

  it "returns list of users that doesn't ordered yet" do
    add_guest("james smith")
    message_from_slack(user_message: "remind")

    bot_response =
      "<@FabienUserId>\n<@WillUserId>\njames smith host: <@id host>"
    expect(fake_response.message).to eq(bot_response)
  end

  it "return list of users that doesn't ordered yet" do
    add_guest("james smith")
    message_from_slack(user_message: "remind")

    bot_response =
      "<@FabienUserId>\n<@WillUserId>\njames smith host: <@id host>"
    expect(fake_response.message).to eq(bot_response)

    message_from_slack(user_message: "remove guest: james smith")
    message_from_slack(user_message: "remind")
    expect(fake_response.message).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "return a list without the people who ordered" do
    message_from_slack(user_message: "order: fish", new_recipient: "FabienUserId")
    message_from_slack(user_message: "order -james-: fish")
    message_from_slack(user_message: "remind")

    expect(fake_response.message).to eq("<@WillUserId>")
  end

  it "return in the channel by default" do
    message_from_slack(user_message: "remind")

    expect(fake_response.user_id).to eq(channel_id)
  end

  it "return confirmation guest order" do
    message_from_slack(user_message: "order -james smith-: burger")

    bot_response = "james smith's order for burger has been placed!"
    expect(fake_response.message).to eq(bot_response)
  end

  it "return no guest when empty" do
    message_from_slack(user_message: "guests?")

    expect(fake_response.message).to eq("no guest")
  end

  it "return list of guests" do
    message_from_slack(user_message: "order: burger")
    message_from_slack(user_message: "order -james smith-: burger")
    message_from_slack(user_message: "order -jean bon-: burger")
    message_from_slack(user_message: "guests?")

    expect(fake_response.message).to eq("james smith\njean bon")
  end

  it "return list of guests after guest removed" do
    message_from_slack(user_message: "order: burger")
    message_from_slack(user_message: "order -james smith-: burger")
    message_from_slack(user_message: "order -jean bon-: burger")
    message_from_slack(user_message: "guests?")

    expect(fake_response.message).to eq("james smith\njean bon")

    message_from_slack(user_message: "remove guest: jean bon")
    message_from_slack(user_message: "guests?")
    expect(fake_response.message).to eq("james smith")
  end

  it "return the sum of food by type" do
    message_from_slack(user_message: "order: burger")
    message_from_slack(user_message: "order -james smith-: burger")
    message_from_slack(user_message: "order -jean bon-: burger")
    message_from_slack(user_message: "order -harry potter-: fish")

    message_from_slack(user_message: "all food orders")
    expect(fake_response.message).to eq("burger: 3\nfish: 1")
  end

  private

  def message_from_slack(args)
    user_message = args[:user_message]
    new_recipient = args[:new_recipient] || recipient
    event_data = create_event_data(user_message, new_recipient)
    message_handler.handle(team_id, event_data)
  end

  def create_event_data(message, recipient)
    {
      "type" => "message",
      "user" => recipient,
      "text" => message,
      "ts" => "1484928006.000013",
      "channel" => channel_id,
      "event_ts" => "1484928006.000013",
    }
  end

  def add_guest(name)
    add_guest = Commands::AddGuest.new
    add_guest.prepare(
      user_message: "add guest: #{name}",
      user_id: "id host",
      date: Days.monday
    )
    add_guest.run
  end
end
