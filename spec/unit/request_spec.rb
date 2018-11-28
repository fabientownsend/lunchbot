require 'request'

RSpec.describe SlackApi::Request do
  it "requests and answer when the type is an event callback" do
    request = SlackApi::Request.new(slack_data(type: "event_callback"))

    expect(request.requires_answer?).to eq(true)
  end

  it "does not request and answer when the type is not an event callback" do
    request = SlackApi::Request.new(slack_data(type: "not_event_callback"))

    expect(request.requires_answer?).to eq(false)
  end

  it "requests and answer when the event type is message" do
    request = SlackApi::Request.new(slack_data(event_type: "message"))

    expect(request.requires_answer?).to eq(true)
  end

  it "does not requests and answer when the event type is not message" do
    request = SlackApi::Request.new(slack_data(event_type: "not_message"))

    expect(request.requires_answer?).to eq(false)
  end

  it "does not requests and answer when the message is from a robot" do
    request = SlackApi::Request.new(slack_data(bot_id: "abc123"))

    expect(request.requires_answer?).to eq(false)
  end

  it "does not requests and answer when the message is from a robot" do
    request = SlackApi::Request.new(slack_data(bot_id: "abc123"))

    expect(request.requires_answer?).to eq(false)
  end

  it "does an answer when the message is not from a robot" do
    request = SlackApi::Request.new(slack_data)

    expect(request.requires_answer?).to eq(true)
  end

  it "has wrong slack verification token" do
    mock_env("SLACK_VERIFICATION_TOKEN", "expected token")
    request = SlackApi::Request.new(slack_data(token: "wrong token"))

    expect(request.valid_token?).to eq(false)
  end

  it "has correct slack verification token" do
    mock_env("SLACK_VERIFICATION_TOKEN", "expected token")
    request = SlackApi::Request.new(slack_data(token: "expected token"))

    expect(request.valid_token?).to eq(true)
  end

  def mock_env(key, value)
    allow(ENV).to receive(:[]).with(key).and_return(value)
  end

  def slack_data(args = {})
    {
      "token" => args[:token] || "expected token",
      "type" => args[:type] || "event_callback",
      "event" => {
        "type" => args[:event_type] || "message",
        "bot_id" => args[:bot_id],
      },
    }
  end
end
