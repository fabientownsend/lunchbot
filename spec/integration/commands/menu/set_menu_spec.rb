require 'commands/menu/set_menu'
require 'models/menu'

RSpec.describe Commands::SetMenu do
  let(:command) { Commands::SetMenu.new }

  before(:each) do
    @foreman = User.new(
      user_name: "Fabien Townsend",
      slack_id: "valid id",
      office: "london",
      is_foreman: true
    )
    @foreman.save

    User.new(
      user_name: "Fabien another user",
      slack_id: "valid id 2",
      office: "london"
    ).save

    User.new(
      user_name: "Fabien Townsend",
      slack_id: "valid id 3"
    ).save
  end

  it "applies to the command" do
    response = command.applies_to?(user_message: "menu: www.menu.com")

    expect(response).to be true
  end

  it "is not case sensitive" do
    response = command.applies_to?(user_message: "Menu: www.menu.com")

    expect(response).to be true
  end

  it "is not space sensitive" do
    response = command.applies_to?(user_message: "  menu:    www.menu.com   ")

    expect(response).to be true
  end

  it "tell you if you don't have the right to set a new url" do
    response = set_menu_link(url: "no an url", overwrite_slack_id: "valid id 2")

    expect(response).to eq("You are not the foreman!")
  end

  it "requires the requester to have an office" do
    response = set_menu_link(url: "no an url", overwrite_slack_id: "valid id 3")

    expect(response).to eq("You need to add your office. ex: \"office: london\"")
  end

  it "tell you when the url isn't valid" do
    response = set_menu_link(url: "no an url")

    expect(response).to eq("That is not a valid URL!")
  end

  it "return a message with a message" do
    url = "http://www.deliveroo.co.uk/menu/london/holborn/itsu-fleet-street"
    response = set_menu_link(url: url)

    expect(response).to eq("<!here> Menu has been set: #{url}")
  end

  it "extracts the first url" do
    response = set_menu_link(url: "menu: <http://www.test.com|www.test.com>")

    expect(response).to eq("<!here> Menu has been set: http://www.test.com")
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

    expect(Menu.last).to have_attributes(
      url: url,
      office: @foreman.office
    )
  end

  it "complains about choosing kin" do
    url = "https://kin.orderswift.com/menu/"
    response = set_menu_link(url: url)

    expect(response).to include("Kin again?! :eye-roll: fine ...")
  end

  private

  def set_menu_link(args)
    url = args[:url]
    from_id = args[:overwrite_slack_id] || "valid id"
    command.prepare(user_message: url, user_id: from_id)
    command.run
  end
end
