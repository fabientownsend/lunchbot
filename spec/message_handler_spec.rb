require 'fake_response'
require 'message_handler'
require 'fake_user_info_provider'
require 'fake_channel_info_provider'
require 'add_guest'
require 'add_apprentice'

RSpec.describe MessageHandler do
  let (:fake_response) { FakeResponse.new }
  let (:fake_user_info_provider) { FakeUserInfoProvider.new }
  let (:fake_channel_info_provider) { FakeChannelInfoProvider.new }
  let (:message_handler) { MessageHandler.new(fake_response, fake_user_info_provider, fake_channel_info_provider) }
  let (:team_id) { "T026MULUJ" }
  let (:recipient) { "D3S6XE6SZ" }

  it "return error when message doesn't mean anything" do
    message_from_slack("invalid request")

    expect(fake_response.message).to eq("This isn't a valid request")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
  end

  it "should return a message for a new menu" do
    message_from_slack("new menu: <http://www.test.com|www.test.com>")

    expect(fake_response.message).to eq("<!here> Menu has been set: http://www.test.com")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
  end

  it "return the url when you ask the menu which is not provided" do
    message_from_slack("menu?")

    expect(fake_response.message).to eq("The menu for this week is: no url provided")
  end

  it "return the url when you ask the menu which is not provided" do
    message_from_slack("new menu: <http://www.test.com|www.test.com>")
    message_from_slack("menu?")

    expect(fake_response.message).to eq("The menu for this week is: http://www.test.com")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
  end

  it "set a new menu for a user" do
    message_from_slack("order me: humberger")

    expect(fake_response.message).to eq("Your order `humberger` is updated")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
  end

  it "return the order of a person" do
    message_from_slack("order me: hamburger")
    message_from_slack("order: <@#{recipient}>")

    expect(fake_response.message).to eq("<@D3S6XE6SZ> ordered: `hamburger`")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
  end

  it "return the foreman of the week" do
    add_apprentice = AddApprentice.new()
    add_apprentice.prepare({user_name: "Will", slack_id: "id"})
    add_apprentice.run

    message_from_slack("foreman")

    expect(fake_response.message).to eq("The foreman for this week is Will")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
  end

  it "return list of different orders" do
    message_from_slack("order me: hamburger")
    recipient = "asdf"
    message_from_slack("order me: fish", "Fabien", recipient)
    message_from_slack("all orders?")

    expect(fake_response.message).to eq("Will: hamburger\nFabien: fish")
  end

  it "return list of users that doesn't ordered yet" do
    add_guest("james smith")
    message_from_slack("remind")

    expect(fake_response.message).to eq("<@FabienUserId>\n<@WillUserId>\njames smith host: <@id host>")
  end

  it "return list of users that doesn't ordered yet" do
    add_guest("james smith")
    message_from_slack("remind")

    expect(fake_response.message).to eq("<@FabienUserId>\n<@WillUserId>\njames smith host: <@id host>")

    message_from_slack("remove guest: james smith")
    message_from_slack("remind")
    expect(fake_response.message).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "return a list without the people who ordered" do
    message_from_slack("order me: fish", "Fabien", "FabienUserId")
    message_from_slack("order -james-: fish")
    message_from_slack("all orders?")
    message_from_slack("remind")

    expect(fake_response.message).to eq("<@WillUserId>")
  end

  it "return confirmation guest order" do
    message_from_slack("order -james smith-: burger")

    expect(fake_response.message).to eq("james smith order saved")
  end

  it "return no guest when empty" do
    message_from_slack("guests?")

    expect(fake_response.message).to eq("no guest")
  end

  it "return list of guests" do
    message_from_slack("order me: burger")
    message_from_slack("order -james smith-: burger")
    message_from_slack("order -jean bon-: burger")
    message_from_slack("guests?")

    expect(fake_response.message).to eq("james smith\njean bon")
  end

  it "return list of order guest included" do
    message_from_slack("order me: burger")
    message_from_slack("order -james smith-: burger")
    message_from_slack("order -jean bon-: burger")
    message_from_slack("add guest: harry potter")
    message_from_slack("all orders?")

    expect(fake_response.message).to eq(
      "Will: burger\n" +
      "james smith: burger\n" +
      "jean bon: burger"
    )
  end

  it "return list of guests after guest removed" do
    message_from_slack("order me: burger")
    message_from_slack("order -james smith-: burger")
    message_from_slack("order -jean bon-: burger")
    message_from_slack("guests?")

    expect(fake_response.message).to eq("james smith\njean bon")

    message_from_slack("remove guest: jean bon")
    message_from_slack("guests?")
    expect(fake_response.message).to eq("james smith")
  end

  private

  def message_from_slack(request, name = "Will", new_recipient = recipient)
    user_message = request
    event_data = create_event_data(user_message, new_recipient, name)
    message_handler.handle(team_id, event_data)
  end

  def create_event_data(message, recipient, name)
    {"type"=>"message", "user"=>"#{recipient}", "text"=>"#{message}", "ts"=>"1484928006.000013", "channel"=>"#{recipient}", "event_ts"=>"1484928006.000013"}
  end

  def add_guest(name)
    add_guest = AddGuest.new
    add_guest.prepare({
      user_message: "add guest: #{name}",
      user_id: "id host"
    })
    add_guest.run
  end
end
