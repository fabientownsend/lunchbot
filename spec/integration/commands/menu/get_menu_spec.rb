# typed: false
require 'commands/menu/get_menu'
require 'models/user'
require 'models/menu'

RSpec.describe Commands::GetMenu do
  let(:get_menu_command) { Commands::GetMenu.new }

  it "applies to menu request" do
    response = get_menu_command.applies_to?(user_message: "menu?")
    expect(response).to be true
  end

  it "not case sensitive" do
    response = get_menu_command.applies_to?(user_message: "Menu?")
    expect(response).to be true
  end

  it "not case space sensitive" do
    response = get_menu_command.applies_to?(user_message: "  menu?  ")
    expect(response).to be true
  end

  it "return that the url isn't provided if it's the case" do
    User.new(
      user_name: "Fabien",
      slack_id: "user id",
      office: "london"
    ).save

    get_menu_command.prepare(user_id: "user id")
    result = get_menu_command.run
    expect(result).to eq("The menu for this week is: no url provided")
  end

  it "does returns the menu from a different office" do
    User.new(
      user_name: "Fabien",
      slack_id: "user id 8",
      office: "london"
    ).save
    Menu.new(url: "www.menu.com", date: Time.now, office: "london").save

    get_menu_command.prepare(user_id: "user id 8")
    result = get_menu_command.run

    expect(result).to eq("The menu for this week is: www.menu.com")
  end

  it "does not return the menu from a different office" do
    User.new(
      user_name: "Fabien",
      slack_id: "user id 8",
      office: "Somewhere else"
    ).save
    Menu.new(url: "www.menu.com", date: Time.now, office: "london").save

    get_menu_command.prepare(user_id: "user id 8")
    result = get_menu_command.run

    expect(result).to eq("The menu for this week is: no url provided")
  end
end
