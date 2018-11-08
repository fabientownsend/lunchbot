require 'commands/order/reminder'
require 'days'
require 'fake_mark_all_out'

RSpec.describe Commands::Reminder do
  let(:reminder) { Commands::Reminder.new }
  let(:data) do
    {
      user_message: "message",
      user_id: "user id",
      user_name: "user name",
      channel_id: "channel id",
      team_id: "team id",
      mark_all_out: FakeMarkAllOut.new,
    }
  end

  before(:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: "user id",
      is_foreman: true
    )
    foreman.save
  end

  it "return all the person that didn't order" do
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "tell you when there is no orders" do
    Helper.order(
      user_id: "FabienUserId",
      user_name: "fabien",
      user_message: "burger",
      date: Days.monday
    )
    Helper.order(
      user_id: "WillUserId",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )

    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("Everyone has an order.")
  end

  it "doesn't remind people who placed an order" do
    Helper.order(
      user_id: "FabienUserId",
      user_name: "will",
      user_message: "burger",
      date: Days.monday
    )

    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@WillUserId>")
  end

  it "doesn't consider the order from the previous weeks" do
    Helper.order_previous_monday(
      user_id: "FabienUserId",
      user_name: "will",
      user_message: "burger"
    )

    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "remind the guest's host if they don't have an order" do
    Helper.add_guest("jean gaston")
    reminder.prepare(data)
    response = reminder.run

    expect(response) .to eq(
      "<@FabienUserId>\n<@WillUserId>\njean gaston host: <@host id>"
    )
  end

  it "doesn't remind guest form the previous weeks" do
    Helper.add_guest_previous_monday("jean gaston")
    reminder.prepare(data)
    response = reminder.run

    expect(response).to eq("<@FabienUserId>\n<@WillUserId>")
  end

  it "return a message when you are not allowed to see the result" do
    reminder.prepare(data.merge(user_id: "another id"))
    response = reminder.run

    expect(response).to eq("You are not the foreman!")
  end
end
