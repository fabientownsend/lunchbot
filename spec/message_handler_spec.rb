require 'commands/foreman/add_apprentice'
require 'commands/help'
require 'commands/order/add_guest'
require 'days'
require 'fake_mark_all_out'
require 'fake_bot'
require 'fake_user_info_provider'
require 'message_handler'

RSpec.describe MessageHandler do
  let(:fake_bot) { FakeBot.new }
  let(:fake_mark_all_out) { FakeMarkAllOut.new }
  let(:fake_user_info_provider) { FakeUserInfoProvider.new }
  let(:recipient) { "D3S6XE6SZ" }
  let(:channel_id) { "CHANNELID" }

  let(:message_handler) do
    MessageHandler.new(
      mark_all_out: fake_mark_all_out,
      bot: fake_bot,
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
    allow(User).to receive(:has_office?).and_return(true)
  end

  it "return all commands info when request is for help" do
    message_from_slack(user_message: "help")

    help_message = <<~HEREDOC
      :bug: Want to report a bug or have an idea for a new feature? :package:
      Share it here: :loudspeaker: <https://github.com/fabientownsend/lunchbot/issues/new> :loudspeaker:

      Join the channel #lunchbot_dev

      Add a guest with no order | `add guest: name of guest`
      Add yourself as the new foreman | `add apprentice`
      Copy someone's order | `copy order: @username`
      Delete a crafter | `delete crafter slack_user_name`
      Find out this week's foreman | `foreman`
      Get this week's menu | `menu?`
      Mark yourself out: `out`
      Place an order for a guest (this also creates a guest if the name given does not exist) | `order -name of guest-: food`
      Place an order | `order: food`
      Remind people with no order | `remind`
      Remove a guest | `remove guest: name of guest`
      See all orders | `all orders?`
      Set a menu | `new menu www.menu-url.com`
      Set an \"apparentice\" as the current foreman | `set foreman: @name_of_the_person`
    HEREDOC

    expect(fake_bot.message).to eq(help_message)
  end

  it "returns the url when you ask the menu which is not provided" do
    User.new(
      user_name: "Fabien",
      slack_id: "user id",
      office: "london"
    ).save

    message_from_slack(user_message: "menu?", new_recipient: "user id")

    bot_response = "The menu for this week is: no url provided"
    expect(fake_bot.message).to eq(bot_response)
  end

  it "responds with the order you just placed" do
    User.create(user_id: recipient, user_name: "Fabien", office: "london")
    message_from_slack(user_message: "order: hamburger")

    expect(fake_bot.message).to eq("Will just ordered `hamburger`.")
    expect(fake_bot.user_id).to eq(channel_id)
  end

  it "tells you if your order is invalid" do
    message_from_slack(user_message: "order:")
    expect(fake_bot.message).to eq("That is not a valid order.")
  end

  it "return in the channel by default" do
    message_from_slack(user_message: "remind")

    expect(fake_bot.user_id).to eq(channel_id)
  end

  it "return confirmation guest order" do
    message_from_slack(user_message: "order -james smith-: burger")

    bot_response = "james smith's order for burger has been placed!"
    expect(fake_bot.message).to eq(bot_response)
  end

  it "return the sum of food by type" do
    User.create(user_id: recipient, user_name: "Fabien", office: "london")
    message_from_slack(user_message: "order: burger")
    message_from_slack(user_message: "order -james smith-: burger")
    message_from_slack(user_message: "order -jean bon-: burger")
    message_from_slack(user_message: "order -harry potter-: fish")
    message_from_slack(user_message: "all food orders")

    expect(fake_bot.message).to eq("burger: 3\nfish: 1")
  end

  private

  def message_from_slack(args)
    user_message = args[:user_message]
    new_recipient = args[:new_recipient] || recipient
    event_data = create_event_data(user_message, new_recipient)
    message_handler.handle(event_data)
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
