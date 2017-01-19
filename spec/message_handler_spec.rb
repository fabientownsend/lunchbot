require 'spec_helper'
require 'request_parser'

RSpec.describe RequestParser do
  let(:user_request) { RequestParser.new }

  it "return menu when the request is a menu" do
    request = "new menu www.menu.com"
    expect(user_request.parse(request)).to eq("menu")
  end

  it "return error when the menu request has too munch arguments" do
    request = "new menu www.menu.com bla"
    expect(user_request.parse(request)).to eq("error")
  end

  it "return error when the menu request hasn't enough arguments " do
    request = "new menu www.menu.com bla"
    expect(user_request.parse(request)).to eq("error")
  end

  it "return error when the request keywork aren't correct" do
    request = "lol menu www.menu.com"
    expect(user_request.parse(request)).to eq("error")
  end

  it "return error when the request doesn't provide an url" do
    request = "new menu no-an-url"
    expect(user_request.parse(request)).to eq("error")
  end
end
