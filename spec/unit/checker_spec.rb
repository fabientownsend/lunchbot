require 'checker'

RSpec.describe SlackApi::Checker do
  it "requests and answer when the type is an event callback" do
    checker = SlackApi::Checker.new(slack_data(type: "event_callback"))

    expect(checker.require_answer?).to eq(true)
  end

  it "does not request and answer when the type is not an event callback" do
    checker = SlackApi::Checker.new(slack_data(type: "not_event_callback"))

    expect(checker.require_answer?).to eq(false)
  end

  it "requests and answer when the event type is message" do
    checker = SlackApi::Checker.new(slack_data(event_type: "message"))

    expect(checker.require_answer?).to eq(true)
  end

  it "does not requests and answer when the event type is not message" do
    checker = SlackApi::Checker.new(slack_data(event_type: "not_message"))

    expect(checker.require_answer?).to eq(false)
  end

  it "does not requests and answer when the message is from a robot" do
    checker = SlackApi::Checker.new(slack_data(bot_id: "abc123"))

    expect(checker.require_answer?).to eq(false)
  end

  it "does an answer when the message is not from a robot" do
    checker = SlackApi::Checker.new(slack_data())

    expect(checker.require_answer?).to eq(true)
  end

  def slack_data(args = {})
    {
      "type" => args[:type] || "event_callback",
      "event" => {
        "type" => args[:event_type] || "message",
        "bot_id" => args[:bot_id]
      }
    }
  end
end
