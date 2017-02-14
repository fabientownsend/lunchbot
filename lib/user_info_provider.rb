require 'net/http'
require 'json'

class UserInfoProvider
    def real_name(user_id, team_id)
      token = $teams[team_id][:bot_access_token]
      url = URI("https://slack.com/api/users.info?token=#{token}&user=#{user_id}&pretty=1")
      return get_real_name(url)
    end

    def email(user_id, team_id)
      token = $teams[team_id][:bot_access_token]
      url = URI("https://slack.com/api/users.info?token=#{token}&user=#{user_id}&pretty=1")
      return get_email(url)
    end

    private

    def get_real_name(url)
      begin
        response = Net::HTTP.get(url)
        deserialized_response = JSON.parse(response)
        return deserialized_response['user']['real_name']
      rescue
        return "no user name provided"
      end
    end

    def get_email(url)
      begin
        response = Net::HTTP.get(url)
        deserialized_response = JSON.parse(response)
        return deserialized_response['user']['profile']['email']
      rescue
        return "no email provided"
      end
    end
end
