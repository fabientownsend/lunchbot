require 'net/http'
require 'json'

class UserInfoProvider
    def real_name(user_id, team_id)
      token = $teams[team_id][:bot_access_token]

      url = URI("https://slack.com/api/users.info?token=#{token}&user=#{user_id}&pretty=1")
      response = Net::HTTP.get(url)
      deserialized_response = JSON.parse(response)

      deserialized_response['user']['real_name']
    end
end
