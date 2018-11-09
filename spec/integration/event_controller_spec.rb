ENV['RACK_ENV'] = 'test'

require 'event_controller'
require 'rspec'
require 'rack/test'
require 'json'

describe EventController do
  include Rack::Test::Methods

  let(:mark_all_out)       { FakeMarkAllOut.new }
  let(:user_info_provider) { FakeUserInfoProvider.new }
  let(:bot)                { double("bot") }

  let(:message_handler) do
    MessageHandler.new(
      bot: bot,
      user_info_provider: user_info_provider,
      mark_all_out: mark_all_out
    )
  end

  let(:app) { EventController.new(message_handler: message_handler) }

  it "responds with the challenge value if the request is for endpoint verification" do
    post '/events', { foo: "bar", type: "url_verification", challenge: "baz" }.to_json

    expect(last_response).to be_ok
    expect(last_response.body).to eql "baz"
  end

  it "fails when the request contains a wrong token" do
    allow(ENV).to receive(:[]).with('SLACK_VERIFICATION_TOKEN').and_return("token")

    post '/events', { token: "wrong-token" }.to_json

    expect(last_response.status).to eql 403
  end

  it "processes user message" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SLACK_VERIFICATION_TOKEN').and_return("token")

    expect(bot).to receive(:send)

    payload = {
      user: "Fabien",
      type: "event_callback",
      token: "token",
      event: { type: "message", text: "all orders?" },
    }.to_json

    post '/events', payload

    expect(last_response.status).to eql 200
  end
end
