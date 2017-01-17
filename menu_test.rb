class Menu
  def menu 
    "www.mymenu.com"
  end
end

RSpec.describe Menu do
  it "return the url of the current menu" do
    menu = Menu.new
    expect(menu.menu).to eq("www.mymenu.com")
  end
end
