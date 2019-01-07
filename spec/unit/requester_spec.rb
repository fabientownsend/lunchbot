require 'requester'
require_relative '../fake_user_info_provider'

RSpec.describe SlackApi::Requester do
  it "parse the request for the commands" do
    requester = SlackApi::Requester.new(slack_api_user: FakeUserInfoProvider.new)

    requester.parse(
      {
        "event" => {
          "text" => "message",
          "user" => "Xe87 ",
        },
      }
    )

    expect(requester.message).to eq("message")
    expect(requester.id).to eq("Xe87 ")
  end

  it "returns information form slack API" do
    requester = SlackApi::Requester.new(
      slack_api_user: FakeUserInfoProvider.new(
        email: "bla@email.com",
        names: ["bob"]
      )
    )

    requester.parse(
      {
        "event" => {
          "text" => "message",
          "user" => "Xe87 ",
        },
      }
    )

    expect(requester.name).to eq("bob")
    expect(requester.email).to eq("bla@email.com")
  end
end
