# typed: false
require 'commands/order/reminder'
require 'days'
require 'fake_mark_all_out'
require 'mark_all_out'

RSpec.describe Commands::Reminder do
  let(:command) { Commands::Reminder.new }
  let(:reminder_request) do
    { user_id: "user id" }
  end

  before(:each) do
    allow(MarkAllOut).to receive(:new).and_return(FakeMarkAllOut.new)
    User.all.destroy

    User.new(
      user_name: "Will",
      slack_id: "user id",
      is_foreman: true
    ).save
  end

  it "returns list of people with line breaker" do
    User.create(user_id: "user id", office: "london")
    User.create(user_id: "WillUserId", office: "london")

    command.prepare(reminder_request)

    expect(command.run).to eq("<@user id>\n<@WillUserId>")
  end

  it "tell you when there is no orders" do
    allow(Order).to receive(:users_without_order).and_return([])
    allow(Order).to receive(:guests_without_order).and_return([])
    User.create(user_id: "user id", office: "london")

    command.prepare(reminder_request)
    response = command.run

    expect(response).to eq("Everyone has an order.")
  end

  it "remind the guest's host if they don't have an order" do
    User.create(user_id: "user id", office: "london")

    Order.create(
      :user_name => "jean gaston",
      :host => "user id",
      :date => Days.monday
    )

    Order.create(
      :user_name => "paul",
      :host => "user id",
      :date => Days.monday
    )

    command.prepare(reminder_request)
    response = command.run

    expect(response) .to eq(
      "<@user id>\njean gaston host: <@user id>\npaul host: <@user id>"
    )
  end

  it "return a message when you are not allowed to see the result" do
    command.prepare(reminder_request.merge(user_id: "another id"))
    response = command.run

    expect(response).to eq("You are not the foreman!")
  end
end
