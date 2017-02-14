require 'commands/menu/set_menu'
require 'models/apprentice'
require 'models/menu'

RSpec.describe SetMenu do
  before(:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: "valid id"
    )
    foreman.save
  end

  it "applies to the command" do
    menu = SetMenu.new
    response = menu.applies_to("new menu www.menu.com")

    expect(response).to be true
  end

  it "is not case sensitive" do
    menu = SetMenu.new
    response = menu.applies_to("New Menu www.menu.com")

    expect(response).to be true
  end

  it "is not space sensitive" do
    menu = SetMenu.new
    response = menu.applies_to("  new menu    www.menu.com   ")

    expect(response).to be true
  end

  it "tell you if you don't have the right to set a new url" do
    url = "no an url"
    response = change_url(url, "invalid id")

    expect(response).to eq("You are not the foreman!")
  end

  it "tell you when the url isn't valid" do
    url = "no an url"
    response = change_url(url)

    expect(response).to eq("That is not a valid URL!")
  end

  it "return a message with a message" do
    url = "http://www.deliveroo.co.uk/menu/london/holborn/itsu-fleet-street"
    response = change_url(url)

    expect(response).to eq("<!here> Menu has been set: #{url}")
  end

  it "save url in database" do
    url = "http://www.deliveroo.co.uk/menu/london/holborn/itsu-fleet-street"
    change_url(url)

    expect(Menu.last.url).to eq("http://www.deliveroo.co.uk/menu/london/holborn/itsu-fleet-street")
  end

  it "remove useless information from url" do
    url = "https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden?day=today&rpos=0&time=1130"
    change_url(url)

    expect(Menu.last.url).to eq("https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden")
  end

  it "accept subdomain" do
    url = "https://arancinibrothers-catering.orderswift.com/menu/re_0UVbTREuhk8Bi9b"
    change_url(url)

    expect(Menu.last.url).to eq("https://arancinibrothers-catering.orderswift.com/menu/re_0UVbTREuhk8Bi9b")
  end

  private

  def change_url(url, from_id = "valid id")
    menu = SetMenu.new
    menu.prepare({user_message: url, user_id: from_id})
    menu.run
  end
end
