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
      bot: fake_response,
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
    allow(Crafter).to receive(:has_office?).and_return(true)
  end

  include CommandInfo

  it "return all commands info when request is for help" do
    message_from_slack(user_message: "help")

    expect(fake_response.message).to eq(all_command_info)
  end

  it "returns the url when you ask the menu which is not provided" do
    Crafter.new(
      user_name: "Fabien",
      slack_id: "user id",
      office: "london"
    ).save

    message_from_slack(user_message: "menu?", new_recipient: "user id")

    bot_response = "The menu for this week is: no url provided"
    expect(fake_response.message).to eq(bot_response)
  end

  it "responds with the order you just placed" do
    Crafter.create(user_id: recipient, user_name: "Fabien", office: "london")
    message_from_slack(user_message: "order: hamburger")

    expect(fake_response.message).to eq("Will just ordered `hamburger`.")
    expect(fake_response.user_id).to eq(channel_id)
  end

  it "tells you if your order is invalid" do
    message_from_slack(user_message: "order:")
    expect(fake_response.message).to eq("That is not a valid order.")
  end

  it "returns list of users that doesn't ordered yet" do
    allow(Crafter).to receive(:profile).and_return(true)
    allow(Apprentice).to receive(:foreman?).and_return(true)
    add_guest("james smith")
    message_from_slack(user_message: "remind")

    bot_response =
      "<@FabienUserId>\n<@WillUserId>\njames smith host: <@id host>"
    expect(fake_response.message).to eq(bot_response)
  end

  it "return list of users that doesn't ordered yet" do
    allow(Crafter).to receive(:profile).and_return(true)
    allow(Apprentice).to receive(:foreman?).and_return(true)
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
    allow(Apprentice).to receive(:foreman?).and_return(true)

    message_from_slack(user_message: "order: fish", new_recipient: "FabienUserId")
    message_from_slack(user_message: "order -james-: pomme")
    message_from_slack(user_message: "remind")

    expect(fake_response.message).to eq("<@WillUserId>\n<@D3S6XE6SZ>")
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

  it "return the sum of food by type" do
    Crafter.create(user_id: recipient, user_name: "Fabien", office: "london")
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
