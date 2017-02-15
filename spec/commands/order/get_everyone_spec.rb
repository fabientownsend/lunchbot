require 'commands/order/get_everyone'

RSpec.describe Commands::GetEveryone do
  let(:get_everyone) { Commands::GetEveryone.new }
  let(:data) do
    {
      user_message: "message",
      user_id: "user id",
      user_name: "user name",
      channel_id: "channel id",
      team_id: "team id"
    }
  end

  it "apply to the command 'everyone'" do
    user_request = "everyone"

    expect(get_everyone.applies_to(user_request)).to eq(true)
  end

  it "apply only only ton 'everyone' command" do
    user_request = "everyone and me"

    expect(get_everyone.applies_to(user_request)).to eq(false)
  end

  it "is not case sensitive" do
    user_request = "Everyone"

    expect(get_everyone.applies_to(user_request)).to eq(true)
  end

  it "is not spaces sensitive" do
    user_request = "  everyone  "

    expect(get_everyone.applies_to(user_request)).to eq(true)
  end

  it "return guests with and without a meal" do
    Helper.add_guest("harry potter")
    Helper.order_guest(name: "james smith", meal: "burger", from: "slack id")

    get_everyone.prepare(data)
    response = get_everyone.run

    expect(response).to eq(
      "<@FabienUserId>\n<@WillUserId>\nharry potter\njames smith: burger"
    )
  end

  it "return crafter with and without meal" do
    Helper.order_guest(name: "james smith", meal: "burger", from: "slack id")
    Helper.order(
      user_id: "FabienUserId",
      user_name: "Fabien",
      user_message: "fish"
    )

    get_everyone.prepare(data)
    response = get_everyone.run

    expect(response).to eq(
      "<@FabienUserId>: fish\n<@WillUserId>\njames smith: burger"
    )
  end
end
