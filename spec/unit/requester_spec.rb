require 'requester'
require_relative '../fake_user_info_provider'

RSpec.describe SlackApi::Requester do
  it "parse the request for the commands" do
    data_from_slack = {
      "event" => {
        "text" => "  MESsage  ",
        "user" => "Xe87 ",
      },
    }

    requester = SlackApi::Requester.new(
      data_from_slack,
      slack_api_user: FakeUserInfoProvider.new
    )

    expect(requester.message).to eq("message")
    expect(requester.id).to eq("Xe87 ")
  end

  it "returns information form slack API" do
    data_from_slack = {
      "event" => {
        "text" => "message",
        "user" => "Xe87 ",
      },
    }

    requester = SlackApi::Requester.new(
      data_from_slack,
      slack_api_user: FakeUserInfoProvider.new(
        email: "bla@email.com",
        names: ["bob"]
      )
    )


    expect(requester.name).to eq("bob")
    expect(requester.email).to eq("bla@email.com")
  end
end
