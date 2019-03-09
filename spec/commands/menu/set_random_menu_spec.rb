require 'commands/menu/set_random_menu'

RSpec.describe Commands::SetRandomMenu do
  it "applies to the command" do
    command = Commands::SetRandomMenu.new
    response = command.applies_to?(user_message: "surprise menu")
    expect(response).to be true
  end
end
