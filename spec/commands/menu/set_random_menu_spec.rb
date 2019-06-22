# typed: false
require 'commands/menu/set_random_menu'

RSpec.describe Commands::SetRandomMenu do
  it "applies to the command" do
    command = Commands::SetRandomMenu.new
    response = command.applies_to?(user_message: "surprise menu")
    expect(response).to be true
  end

  it "returns a random menu" do
    User.new(
      user_name: "Fabien Townsend",
      slack_id: "valid id",
      office: "london",
      is_foreman: true
    ).save

    command = Commands::SetRandomMenu.new
    data = { user_id: "valid id" }

    allow(command).to receive(:random_url).and_return("foo.com")

    command.prepare(data)

    expect(command.run).to include("foo.com")
  end

  it "returns a random menu URL from past orders" do
    Menu.new(url: "foo", office: "Winterfell").save
    Menu.new(url: "bar", office: "Winterfell").save

    User.new(
      user_name: "Fabien Townsend",
      slack_id: "valid id",
      office: "Winterfell",
      is_foreman: true
    ).save

    command = Commands::SetRandomMenu.new
    data = { user_id: "valid id" }

    command.prepare(data)

    expect(command.run).to include("foo").or(include("bar"))
  end
end
