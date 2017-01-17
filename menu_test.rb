require_relative 'menu'

RSpec.describe Menu do
  it "return the url of the current menu" do
    menu = Menu.new
    expect(menu.url).to eq("www.mymenu.com")
  end
  #@menu_url = /((http|https):\/{2})+([A-Za-z]+\.)+(com|co.uk)/.match(event_data['message'])
end
