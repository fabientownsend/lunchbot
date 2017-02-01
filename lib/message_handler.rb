require 'request_parser'
require 'response'
require 'user_info_provider'
require 'channel_info_provider'

class MessageHandler
  def initialize(response = Response.new, user_info = UserInfoProvider.new, channel_info = ChannelInfoProvider.new)
    @user_info = user_info
    @channel_info = channel_info
    @response = response
    @request_parser = RequestParser.new()
  end

  def handle(team_id, event_data)
    data = format_data(team_id, event_data)
    returned_command = @request_parser.parse(data)
    response = returned_command.run()

    if response
      if respond_privately(event_data['text'])
        respond(response, team_id, event_data['user'])
      else
        respond(response, team_id, event_data['user'], event_data['channel'])
      end
    end
  end

  private

  def respond_privately(message)
    message.downcase.end_with?(" private")
  end

  def format_data(team_id, event_data)
    data = {
      user_message: event_data['text'],
      user_id: event_data['user'],
      user_name: @user_info.real_name(event_data['user'], team_id),
      channel_info: @channel_info,
      channel_id: event_data['channel'],
      team_id: team_id
    }
  end

  def respond(bot_answer, team_id, user_id, channel = user_id)
    @response.send(bot_answer, team_id, channel)
  end
end
