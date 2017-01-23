require_relative 'menu'

class MenuCommand
  attr_reader :team_id;
  attr_reader :user_message;
  attr_reader :user_id;
  attr_reader :channel;
  attr_reader :menu;

  def initialize(team_id, event_data)
    @team_id = team_id
    @user_message = event_data['text']
    @user_id = event_data['user']
    @channel = event_data['channel']
    @menu = Menu.new
  end
  
  def run()
    save_menu_url(user_message)
    bot_answer = "<!here> Menu has been set :#{@menu.url}"
    respondToMessage(@bot_answer, @team_id, @user_id, @channel)
  end
  
  private 

  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end
end
