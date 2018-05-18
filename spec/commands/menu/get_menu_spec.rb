require 'commands/menu/get_menu'

RSpec.describe Commands::GetMenu do
  let(:get_menu_command) { Commands::GetMenu.new }

  it "applies to menu request" do
    response = get_menu_command.applies_to({user_message: "menu?"})
    expect(response).to be true
  end

  it "not case sensitive" do
    response = get_menu_command.applies_to({user_message: "Menu?"})
    expect(response).to be true
  end

  it "not case space sensitive" do
    response = get_menu_command.applies_to({user_message: "  menu?  "})
    expect(response).to be true
  end

  it "return that the url isn't provided if it's the case" do
    result = get_menu_command.run
    expect(result).to eq("The menu for this week is: no url provided")
  end
end
