require 'mark_all_out'
require 'request_parser'
require 'response'
require 'user_info_provider'

class MessageHandler
  def initialize(args = {})
    @mark_all_out = args[:mark_all_out] || MarkAllOut.new
    @request_parser = RequestParser.new
    @response = args[:response] || Response.new
    @user_info = args[:user_info_provider] || UserInfoProvider.new
  end

  def start_to_ping(response, team_id, event_data)
    respond(response, team_id, event_data['user'], event_data['channel'])
    sleep 600
    start_to_ping(response, team_id, event_data)
  end

  def handle(team_id, event_data)
    data = format_data(team_id, event_data)
    returned_command = @request_parser.parse(data)
    response = returned_command.run()

    if response == "ping"
      start_to_ping(response, team_id, event_data)
    end

    if response
      if respond_privately(returned_command)
        respond(response, team_id, event_data['user'])
      else
        respond(response, team_id, event_data['user'], event_data['channel'])
      end
    end
  end

  private

  def respond_privately(command)
    command.kind_of? GetAllOrders or command.kind_of? Help
  end

  def format_data(team_id, event_data)
    {
      user_message: event_data['text'],
      user_id: event_data['user'],
      user_name: @user_info.real_name(event_data['user'], team_id),
      user_email: @user_info.email(event_data['user'], team_id),
      channel_id: event_data['channel'],
      team_id: team_id,
      mark_all_out: @mark_all_out
    }
  end

  def respond(bot_answer, team_id, user_id, channel = user_id)
    @response.send(bot_answer, team_id, channel)
  end
end
