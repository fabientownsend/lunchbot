require_relative '../menu'

RSpec.describe Menu do
  it "notify if no link provided" do
    menu = Menu.new
    expect(menu.url).to eq("no link provided")
  end

  it "we can change the default url" do
    menu = Menu.new
    menu.set_url("www.newmenu.com")
    expect(menu.url).to eq("www.newmenu.com")
  end

  it "return the url without the www" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla http://menu.com asdfad")
    expect(url).to eq("http://menu.com")
  end

  it "return the com url" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla http://www.menu.com asdfad")
    expect(url).to eq("http://www.menu.com")
  end

  it "return the co.uk url" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla http://www.menu.co.uk asdfad")
    expect(url).to eq("http://www.menu.co.uk")
  end

  it "return url with numbers" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla http://www.m1234enu.co.uk asdfad")
    expect(url).to eq("http://www.m1234enu.co.uk")
  end

  it "return url with -" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla http://www.m-enu.co.uk asdfad")
    expect(url).to eq("http://www.m-enu.co.uk")
  end

  it "return the url without the http" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla www.menu.co.uk asdfad")
    expect(url).to eq("www.menu.co.uk")
  end

  it "return the url with https" do
    menu = Menu.new
    url = menu.parse_url("asdfj dasfjkla https://www.menu.co.uk asdfad")
    expect(url).to eq("https://www.menu.co.uk")
  end
end
