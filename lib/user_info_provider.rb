require 'net/http'
require 'json'

class UserInfoProvider
    def real_name(user_id, team_id)
      token = $teams[team_id][:bot_access_token]
      real_name = "no user name provided"

      url = URI("https://slack.com/api/users.info?token=#{token}&user=#{user_id}&pretty=1")

      begin
        response = Net::HTTP.get(url)
        deserialized_response = JSON.parse(response)
        real_name = deserialized_response['user']['real_name']
      end

      real_name
    end
end
