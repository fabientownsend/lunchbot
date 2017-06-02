require 'json'
require 'httparty'

class UserInfoProvider
  include HTTParty

  base_uri "https://slack.com/api/users.info?token="

    def real_name(user_id)
      data = user_data(user_id)
      data['error'].nil? ? data['user']['real_name'] : data['error']
    end

    def email(user_id)
      data = user_data(user_id)
      data['error'].nil? ? data['user']['email'] : data['error']
    end

  private

  def user_data(user_id)
    data = self.class.get("#{token}&user=#{user_id}&pretty=1")
    JSON.parse(data.body)
  end

  def token
    team_id = ENV['TEAM_ID']
    $teams[team_id][:bot_access_token]
  end
end
