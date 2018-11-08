ENV['RACK_ENV'] = 'test'

require 'event_controller'
require 'rspec'
require 'rack/test'
require 'json'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    EventController
  end

  it "responds with the challenge value if the request is for endpoint verification" do
    post '/events', { foo: "bar", type: "url_verification", challenge: "baz" }.to_json

    expect(last_response).to be_ok
    expect(last_response.body).to eql "baz"
  end

  it "fails when the request contains a wrong token" do
    cached_token = ENV['SLACK_VERIFICATION_TOKEN']

    ENV['SLACK_VERIFICATION_TOKEN'] = "token"

    post '/events', { token: "wrong-token" }.to_json

    expect(last_response.status).to eql 403

    ENV['SLACK_VERIFICATION_TOKEN'] = cached_token
  end
end
