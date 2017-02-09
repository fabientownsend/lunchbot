require 'commands/order/get_everyone'

RSpec.describe GetEveryone do
  let (:data) {
    {
      user_message: "message",
      user_id: "user id",
      user_name: "user name",
      channel_id: "channel id",
      team_id: "team id",
    }
  }

  it "apply to the command 'everyone'" do
    user_request = "everyone"
    get_everyone = GetEveryone.new

    expect(get_everyone.applies_to(user_request)).to eq(true)
  end

  it "apply only only ton 'everyone' command" do
    user_request = "everyone and me"
    get_everyone = GetEveryone.new

    expect(get_everyone.applies_to(user_request)).to eq(false)
  end

  it "is not case sensitive" do
    user_request = "Everyone"
    get_everyone = GetEveryone.new

    expect(get_everyone.applies_to(user_request)).to eq(true)
  end

  it "is not spaces sensitive" do
    user_request = "  everyone  "
    get_everyone = GetEveryone.new

    expect(get_everyone.applies_to(user_request)).to eq(true)
  end

  it "return guests with and without a meal" do
    Helper.add_guest("harry potter")
    Helper.order_guest({name: "james smith", meal: "burger", from: "slack id"})

    get_everyone = GetEveryone.new
    get_everyone.prepare(data)
    response = get_everyone.run

    expect(response).to eq(
      "<@FabienUserId>\n" +
      "<@WillUserId>\n" +
      "harry potter\n" +
      "james smith: burger"
      )
  end

  it "return crafter with and without meal" do
    Helper.order_guest({name: "james smith", meal: "burger", from: "slack id"})
    Helper.order({
      user_id: "FabienUserId",
      user_name: "Fabien",
      user_message: "fish",
    })

    get_everyone = GetEveryone.new
    get_everyone.prepare(data)
    response = get_everyone.run

    expect(response).to eq(
      "<@FabienUserId>: fish\n" +
      "<@WillUserId>\n" +
      "james smith: burger"
    )
  end
end
