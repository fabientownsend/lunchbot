require 'models/menu'
require 'models/apprentice'
require 'foreman_checker'
require 'feature_flag'

module Commands
  class SetMenu < FeatureFlag
    release_for 'Fabien Townsend', 'Marion'
    include ForemanChecker

    def applies_to(request)
      request = request[:user_message].downcase
      request = request.downcase.strip
      request.split.size == 3 && request.include?("new menu")
    end

    def prepare(data)
      @user_message = data[:user_message]
      @apprentice = Apprentice.profile(data[:user_id])
    end

    def run
      if feature_access?(@apprentice.user_name) && !@apprentice.office
        return "You need to add your office. ex: \"office: london\""
      end

      return "You are not the foreman!" unless foreman?(@apprentice.slack_id)

      update_url
    end

    private

    def update_url
      if extract_url(@user_message)
        save_url(extract_url(@user_message))
        "<!here> Menu has been set: #{extract_url(@user_message)}"
      else
        "That is not a valid URL!"
      end
    end

    def extract_url(request)
      protocol = "((http|https):\/\/)?(w{3}.)"
      subdomain = "[A-Za-z0-9-]+."
      domain = "[A-Za-z0-9-]+.(com|co.uk)"
      path = "([a-zA-Z0-9_\.\/\-]+)"
      request[/#{protocol}?#{subdomain}?#{domain}#{path}?/]
    end

    def save_url(url)
      Menu.new(url: url, date: Time.now, office: @apprentice.office).save
    end
  end
end
