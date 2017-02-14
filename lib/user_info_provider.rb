require 'json'
require 'httparty'

class UserInfoProvider
    include HTTParty

    base_uri "https://slack.com/api/users.info?token="

    def real_name(user_id, team_id)
      user_data['user']['real_name']
    end

    def email
      user_data['user']['email']
    end

    private

    def user_data(user_id)
      data = self.class.get("#{token}&user=#{user_id}&pretty=1")
      JSON.parse(data.body)
    end

    def token
      $teams[team_id][:bot_access_token]
    end
end
