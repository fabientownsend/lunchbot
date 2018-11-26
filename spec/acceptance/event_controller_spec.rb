require 'json'
require 'rack/test'

require 'event_controller'

RSpec.describe EventController do
  include Rack::Test::Methods

  let(:bot) { FakeBot.new }
  let(:message_handler) do
    MessageHandler.new(
      bot: bot,
      user_info_provider: FakeUserInfoProvider.new,
      mark_all_out: FakeMarkAllOut.new
    )
  end
  let(:app) { EventController.new(message_handler: message_handler) }

  context "slack verification" do
    it "returns challenges value when request type is url_verification" do
      challenge_request = { type: "url_verification", challenge: "challenge_value" }

      post '/events', JSON.generate(challenge_request)

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("challenge_value")
    end

    it "raise an error when the token is incorrect" do
      allow(ENV).to receive(:[]).with('SLACK_VERIFICATION_TOKEN').and_return("expected token")
      challenge_request = { token: "different tocket" }

      post '/events', JSON.generate(challenge_request)

      expect(last_response.status).to eq(403)
      expect(last_response.body).to include("Invalid Slack verification token")
    end

    it "goes through when token is correct" do
      allow(ENV).to receive(:[]).with('SLACK_VERIFICATION_TOKEN').and_return("expected token")
      challenge_request = { token: "expected token" }

      post '/events', JSON.generate(challenge_request)

      expect(last_response.status).to eq(200)
    end
  end

  context "request handling" do
    it "calls the message handle request is from user" do
      post '/events', payload

      expect(last_response.status).to eq(200)
      expect(bot.receive).to eq("You need to add your office. ex: \"office: london\"")
    end

    it "does nothing when type is an event_callback" do
      post '/events', payload(type: "not_event_callback")

      expect(bot.receive).not_to eq("You need to add your office. ex: \"office: london\"")
    end

    it "does nothing when type is not a message" do
      post '/events', payload(event_type: "not_message")

      expect(bot.receive).not_to eq("You need to add your office. ex: \"office: london\"")
    end

    it "does nothing when request is from a bot" do
      post '/events', payload(bot: true)

      expect(bot.receive).not_to eq("You need to add your office. ex: \"office: london\"")
    end

    def payload(args = {})
      JSON.generate({
        user: "Fabien",
        type: args[:type] || "event_callback",
        event: {
          type: args[:event_type] || "message",
          text: "menu?",
          bot_id: args[:bot],
        },
      })
    end
  end
end

class FakeBot
  def send(message)
    @message = message
  end

  def receive
    @message
  end
end
