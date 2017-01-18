require 'spec_helper'

class RequestParser
  def parse(request)
    if request.include?("menu")
      "menu"
    elsif request.include?("order")
      "order"
    end
  end
end

RSpec.describe RequestParser do
  it "return menu when its a menu request" do
    request_parser = RequestParser.new
    slack_request = "menu"

    expect(request_parser.parse(slack_request)).to eq("menu")
  end

  it "return order when they try to order" do
    request_parser = RequestParser.new
    slack_request = "order chicken"

    expect(request_parser.parse(slack_request)).to eq("order")
  end
end
