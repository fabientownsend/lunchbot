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
    menu.prepare({user_message: "sdf fdas fsa www.menu.com asdfas"})
    response = menu.run
    expect(response).to eq("<!here> Menu has been set: www.menu.com")
  end
end
