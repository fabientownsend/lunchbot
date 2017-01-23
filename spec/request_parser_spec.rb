require 'request_parser'
require 'spec_helper'

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

  it "return get_menu when the person request for a menu" do
    request = "menu?"
    expect(user_request.parse(request)).to eq("get_menu")
  end

  it "return error when get_menu request has more than one argument" do
    request = "menu? ?"
    expect(user_request.parse(request)).to eq("error")
  end

  it "return set_order when it's a correct order request" do
    request = "order me: name_of_the_menu"
    expect(user_request.parse(request)).to eq("set_order")
  end

  it "return error when there is no space between colon and order" do
    request = "order me:my meal"
    expect(user_request.parse(request)).to eq("error")
  end

  it "return error when the user order nothing" do
    request = "order me:"
    expect(user_request.parse(request)).to eq("error")
  end

  it "return get_order when it's a correct request" do
    correct_request = "order: Fabien Townsend"
    expect(user_request.parse(correct_request)).to eq("get_order")
  end

  it "return error when it's a incorrect request" do
    correct_request = "order:"
    expect(user_request.parse(correct_request)).to eq("error")
  end

  it "return foreman when it's a correct request" do
    correct_request = "foreman"
    expect(user_request.parse(correct_request)).to eq("foreman")
  end
end
