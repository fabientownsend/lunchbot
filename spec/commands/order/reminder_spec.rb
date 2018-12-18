require 'commands/order/reminder'
require 'days'
require 'fake_mark_all_out'

RSpec.describe Commands::Reminder do
  let(:reminder) { Commands::Reminder.new }
  let(:reminder_request) do
    {
      user_id: "user id",
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

  it "returns list of people with line breaker" do
    User.all.destroy
    User.create(user_id: "user id", office: "london")
    User.create(user_id: "WillUserId", office: "london")

    reminder.prepare(reminder_request)

    expect(reminder.run).to eq("<@user id>\n<@WillUserId>")
  end

  it "tell you when there is no orders" do
    allow(Order).to receive(:user_without_order).and_return([])
    allow(Order).to receive(:host_without_order).and_return([])
    User.create(user_id: "user id", office: "london")

    reminder.prepare(reminder_request)
    response = reminder.run

    expect(response).to eq("Everyone has an order.")
  end

  it "remind the guest's host if they don't have an order" do
    User.all.destroy
    User.create(user_id: "user id", office: "london")

    Order.new(
      :user_name => "jean gaston",
      :host => "user id",
      :date => Days.monday
    ).save

    Order.new(
      :user_name => "paul",
      :host => "user id",
      :date => Days.monday
    ).save

    reminder.prepare(reminder_request)
    response = reminder.run

    expect(response) .to eq(
      "<@user id>\njean gaston host: <@user id>\npaul host: <@user id>"
    )
  end

  it "return a message when you are not allowed to see the result" do
    reminder.prepare(reminder_request.merge(user_id: "another id"))
    response = reminder.run

    expect(response).to eq("You are not the foreman!")
  end
end
