require 'set_menu_command'
require 'menu'
require 'spec_helper'

RSpec.describe SetMenuCommand do
  let (:menu) { SetMenuCommand.new }

  it "we can change the default url" do
    menu.prepare({user_message: "www.menu.com"})
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
    expect(Menu.last.url).to eq("www.menu.com")
  end

  it "return the url without the www" do
    menu = SetMenuCommand.new
    menu.prepare({user_message: "sdf fdas fsa asdf.com asdfas"})
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
  end

  it "return deliveroo url" do
    menu = SetMenuCommand.new
    url = "https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden?day=today&rpos=0&time=1130"
    menu.prepare({user_message: "sdf fdas fsa #{url} asdfas"})
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: https://deliveroo.co.uk/menu/london/covent-garden/the-real-greek-covent-garden")
  end
end
