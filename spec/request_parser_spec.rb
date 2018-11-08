require 'commands/menu/set_menu'
require 'commands/menu/get_menu'
require 'request_parser'

RSpec.describe RequestParser do
  let(:user_request) { RequestParser.new }

  it "is not case sensitive" do
    request = { user_message: "NEW mEnU www.mENU.CoM" }
    expect(user_request.parse(request)).to be_a(Commands::SetMenu)
  end

  it "return menu when the request is a menu" do
    request = { user_message: "new menu www.menu.com" }
    expect(user_request.parse(request)).to be_a(Commands::SetMenu)
  end

  it "returns set foreman when the request is to a set the foreman" do
    request = { user_message: "set foreman: " }
    expect(user_request.parse(request)).to be_a(Commands::SetForeman)
  end

  it "return copy order when the request is to copy an order" do
    request = { user_message: "copy order: " }
    expect(user_request.parse(request)).to be_a(Commands::CopyOrder)
  end

  it "returns help when request is help" do
    request = { user_message: "help" }
    expect(user_request.parse(request)).to be_a(Commands::Help)
  end

  it "return out when the request is to be marked out" do
    request = { user_message: "out" }
    expect(user_request.parse(request)).to be_a(Commands::MarkOut)
  end

  it "return get_menu when the person request for a menu" do
    request = { user_message: "menu?" }
    expect(user_request.parse(request)).to be_a(Commands::GetMenu)
  end

  it "return place_order when it's a correct order request" do
    request = { user_message: "order: name_of_the_menu" }
    expect(user_request.parse(request)).to be_a(Commands::PlaceOrder)
  end

  it "return get_order when it's a correct request" do
    request = { user_message: "order? Fabien Townsend" }
    expect(user_request.parse(request)).to be_a(Commands::GetOrder)
  end

  it "return foreman when it's a correct request" do
    request = { user_message: "foreman" }
    expect(user_request.parse(request)).to be_a(Commands::GetForeman)
  end

  it "return all orders command  when it's a correct request" do
    request = { user_message: "all orders?" }
    expect(user_request.parse(request)).to be_a(Commands::GetAllOrders)
  end

  it "return PlaceOrderGuest when it's a correct request" do
    request = { user_message: "order -james smith-: burger" }
    expect(user_request.parse(request)).to be_a(Commands::PlaceOrderGuest)
  end

  it "return RemoveGuestOrder" do
    request = { user_message: "remove guest: james" }
    expect(user_request.parse(request)).to be_a(Commands::RemoveGuestOrder)
  end

  it "return AddGuest" do
    request = { user_message: "add guest: james" }
    expect(user_request.parse(request)).to be_a(Commands::AddGuest)
  end

  it "returns AddApprentice" do
    request = { user_message: "add apprentice" }
    expect(user_request.parse(request)).to be_a(Commands::AddApprentice)
  end

  it "returns RemoveApprentice" do
    request = { user_message: "remove apprentice" }
    expect(user_request.parse(request)).to be_a(Commands::RemoveApprentice)
  end

  it "return remind command when it's a remind request" do
    request = {
      user_message: "remind",
      channel_id: "asdf",
      team_id: "team id",
    }

    expect(user_request.parse(request)).to be_a(Commands::Reminder)
  end
end
