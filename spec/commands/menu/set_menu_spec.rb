require 'commands/menu/set_menu'
require 'models/apprentice'
require 'models/menu'

RSpec.describe Commands::SetMenu do
  let(:menu) { Commands::SetMenu.new }

  before(:each) do
    @foreman = Apprentice.new(
      user_name: "Fabien Townsend",
      slack_id: "valid id",
      office: "london"
    )
    @foreman.save

    Apprentice.new(
      user_name: "Fabien another apprentice",
      slack_id: "valid id 2"
    ).save

    Apprentice.new(
      user_name: "Fabien Townsend",
      slack_id: "valid id 3"
    ).save
  end

  it "applies to the command" do
    response = menu.applies_to(user_message: "new menu www.menu.com")

    expect(response).to be true
  end

  it "is not case sensitive" do
    response = menu.applies_to(user_message: "New Menu www.menu.com")

    expect(response).to be true
  end

  it "is not space sensitive" do
    response = menu.applies_to(user_message: "  new menu    www.menu.com   ")

    expect(response).to be true
  end

  it "tell you if you don't have the right to set a new url" do
    url = "no an url"
    response = set_menu_link(url: url, overwrite_slack_id: "valid id 2")

    expect(response).to eq("You are not the foreman!")
  end

  it "test the new feature whish require office" do
    url = "no an url"
    response = set_menu_link(url: url, overwrite_slack_id: "valid id 3")

    expect(response).to eq("You need to add your office. ex: \"office: london\"")
  end

  it "tell you when the url isn't valid" do
    url = "no an url"
    response = set_menu_link(url: url)

    expect(response).to eq("That is not a valid URL!")
  end

  it "return a message with a message" do
    url = "http://www.deliveroo.co.uk/menu/london/holborn/itsu-fleet-street"
    response = set_menu_link(url: url)

    expect(response).to eq("<!here> Menu has been set: #{url}")
  end

  it "remove useless information from url" do
    url = "https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek" \
    "?day=today&rpos=0&time=1130"
    set_menu_link(url: url)

    result = "https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek"
    expect(Menu.last.url).to eq(result)
  end

  it "accept subdomain" do
    url = "https://arancinibrothers-catering.orderswift.com/menu/re_0UV"
    set_menu_link(url: url)

    expect(Menu.last.url).to eq(url)
  end

  it "can extract url with an apostrof" do
    url = "https://deliveroo.co.uk/menu/london/st-paul's/vita-mojo"
    set_menu_link(url: url)

    expect(Menu.last.url).to eq(url)
  end

  it "save save the office based on forman office " do
    url = "https://arancinibrothers-catering.orderswift.com/menu/re_0UV"
    set_menu_link(url: url)

    expect(Menu.last.url).to eq(url)
    expect(Menu.last.office).to eq(@foreman.office)
  end

  private

  def set_menu_link(args)
    url = args[:url]
    from_id = args[:overwrite_slack_id] || "valid id"
    menu.prepare(user_message: url, user_id: from_id)
    menu.run
  end
end
