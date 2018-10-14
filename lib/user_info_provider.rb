require 'json'
require 'httparty'
require 'tiny_logger'

class UserInfoProvider
  include HTTParty

  base_uri "https://slack.com/api/users.info?token="

  def real_name(user_id)
    data = user_data(user_id)
    Logger.info("USER INFORMATION REQUESTED: data")
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
  rescue StandardError => error
    Logger.alert(error)
  end

  def token
    ENV['SLACK_OAUTH_ACCESS_TOKEN']
  end
end
