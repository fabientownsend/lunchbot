require 'spec_helper'
require 'commands/menu/set_menu_command'
require 'models/menu'

RSpec.describe SetMenuCommand do
  let (:menu) { SetMenuCommand.new }
  let (:fake_data) {{user_message: "www.menu.com", user_id: "id"}}

  before(:each) do
    foreman = Apprentice.new(
      user_name: "Will",
      slack_id: "id"
    )
    foreman.save
  end

  it "we can change the default url" do
    menu.prepare(fake_data)
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
    expect(Menu.last.url).to eq("www.menu.com")
  end

  it "return the url without the www" do
    menu = SetMenuCommand.new
    menu.prepare({user_message: "sdf fdas fsa www.menu.com asdfas", user_id: "id"})
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
  end

  it "does not work if you are not the foreman" do
    menu = SetMenuCommand.new
    menu.prepare({user_message: "www.menu.com", user_id: "wrong_id"})
    response = menu.run
    expect(response).to eq("You are not the foreman!")
  end

  it "return deliveroo url" do
    menu = SetMenuCommand.new
    url = "https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden?day=today&rpos=0&time=1130"
    menu.prepare({user_message: "sdf fdas fsa #{url} asdfas", user_id: "id"})
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden")
  end
end
