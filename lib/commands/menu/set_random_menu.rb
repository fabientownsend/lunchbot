require 'models/menu'

module Commands
  class SetRandomMenu
    def applies_to?(request)
      request = request[:user_message].downcase.strip
      request.include?("surprise menu")
    end

    def prepare(data)
      @user = User.profile(data[:user_id])
      @random_menu_url = random_url
    end

    def run
      return "You need to add your office. ex: \"office: london\"" unless @user.office
      return "You are not the foreman!" unless foreman?(@user)

      save_menu(@random_menu_url)
      "<!here> Surprise! :gift: Menu has been set: #{@random_menu_url}"
    end

    private

    def random_url
      past_menus.sample
    end

    def past_menus
      repository(:default).adapter.select(past_menus_query, @user.office)
    end

    def past_menus_query
      "SELECT DISTINCT url FROM menus WHERE office = ?"
    end

    def foreman?(user)
      User.foreman?(user.slack_id)
    end

    def save_menu(url)
      Menu.new(url: url, date: Time.now, office: @user.office).save
    end
  end
end
