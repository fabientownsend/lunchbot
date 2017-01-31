require 'net/http'
require 'json'

class ChannelInfoProvider
    def members(channel_id, team_id)
      token = $teams[team_id][:bot_access_token]
      channel_members = Array.new

      url = URI("https://slack.com/api/channels.info?token=#{token}&channel=#{channel_id}&pretty=1")

      begin
        response = Net::HTTP.get(url)
        deserialized_response = JSON.parse(response)

        if deserialized_response['channel']
          channel_members = deserialized_response['channel']['members']
        end
      end

      channel_members
    end
end
