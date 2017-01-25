require 'fake_response'
require 'message_handler'

RSpec.describe MessageHandler do
  let (:fake_response) { FakeResponse.new }
  let (:message_handler) { MessageHandler.new(fake_response) }
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

    expect(fake_response.message).to eq("The menu for this week is: no link provided")
    expect(fake_response.team_id).to eq(team_id)
    expect(fake_response.user_id).to eq(recipient)
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

  private

  def message_from_slack(request, name = "Will", new_recipient = recipient)
    user_message = request
    event_data = create_event_data(user_message, new_recipient, name)
    message_handler.handle(team_id, event_data)
  end

  def create_event_data(message, recipient, name)
    {"name" => "#{name}", "type"=>"message", "user"=>"#{recipient}", "text"=>"#{message}", "ts"=>"1484928006.000013", "channel"=>"#{recipient}", "event_ts"=>"1484928006.000013"}
  end
end
