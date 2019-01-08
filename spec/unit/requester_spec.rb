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
    expect(requester.has_message?).to eq(true)
  end

  it "says if the requester has not a message" do
    requester = SlackApi::Requester.new(
      slack_api_user: FakeUserInfoProvider.new(
        email: "bla@email.com",
        names: ["bob"]
      )
    )

    requester.parse(
      {
        "event" => {
          "user" => "Xe87 ",
        },
      }
    )

    expect(requester.has_message?).to eq(false)
  end

  it "recipient is a channel if channel is part of the data structure" do
    requester = SlackApi::Requester.new(
      slack_api_user: FakeUserInfoProvider.new(
        email: "bla@email.com",
        names: ["bob"]
      )
    )

    requester.parse(
      {
        "event" => {
          "user" => "user ",
          "channel" => "channel",
        },
      }
    )

    expect(requester.recipient).to eq("channel")
  end

  it "recipient is a user if channel is part of the data structure" do
    requester = SlackApi::Requester.new(
      slack_api_user: FakeUserInfoProvider.new(
        email: "bla@email.com",
        names: ["bob"]
      )
    )

    requester.parse(
      {
        "event" => {
          "user" => "user",
        },
      }
    )

    expect(requester.recipient).to eq("user")
  end
end
