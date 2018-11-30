require 'requester'

RSpec.describe SlackApi::Requester do
  it "parse the request for the commands" do
    t = {
      "event" => {
        "text" => "  MESsage  ",
        "user" => "Xe87 ",
      },
    }

    requester = SlackApi::Requester.new(t)

    expect(requester.message).to eq("message")
    expect(requester.user_id).to eq("Xe87 ")
  end
end
