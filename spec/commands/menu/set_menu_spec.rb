require 'commands/menu/set_menu_command'
require 'models/apprentice'
require 'models/menu'
require 'spec_helper'

RSpec.describe SetMenuCommand do
  before(:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: "valid id"
    )
    foreman.save
  end

  it "applies to the command" do
    menu = SetMenuCommand.new
    response = menu.applies_to("new menu www.menu.com")

    expect(response).to be true
  end

  it "is not case sensitive" do
    menu = SetMenuCommand.new
    response = menu.applies_to("New Menu www.menu.com")

    expect(response).to be true
  end

  it "is not space sensitive" do
    menu = SetMenuCommand.new
    response = menu.applies_to("  new menu    www.menu.com   ")

    expect(response).to be true
  end

  it "we can change the default url" do
    response = set_menu("www.menu.com")
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
    expect(Menu.last.url).to eq("www.menu.com")
  end

  it "return the url without the www" do
    response = set_menu("sdf fdas fsa www.menu.com asdfas")
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
  end

  it "does not work if you are not the foreman" do
    response = set_menu("sdf fdas fsa www.menu.com asdfas", "invalid id")
    expect(response).to eq("You are not the foreman!")
  end

  it "return deliveroo url" do
    url = "https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden?day=today&rpos=0&time=1130"
    response = set_menu(url)
    expect(response).to eq("<!here> Menu has been set: https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden")
  end

  private

  def set_menu(url, id = "valid id")
    menu = SetMenuCommand.new
    menu.prepare({user_message: "sdf fdas fsa #{url} asdfas", user_id: id})
    menu.run
  end
end
