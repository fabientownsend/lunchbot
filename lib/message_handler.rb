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

  def handle(team_id, event_data)
    returned_command = @request_parser.parse(format_data(team_id, event_data))
    deal_with_command(returned_command, team_id, event_data) unless returned_command.nil?
  end

  private

  def deal_with_command(command, team_id, event_data)
    response = command.run
    if respond_privately(command)
      respond(response, team_id, event_data['user'])
    else
      respond(response, team_id, event_data['user'], event_data['channel'])
    end
  end

  def respond_privately(command)
    command.kind_of? Commands::GetAllOrders or command.kind_of? Commands::Help
  end

  def format_data(team_id, event_data)
    {
      user_message: event_data['text'],
      user_id: event_data['user'],
      user_name: @user_info.real_name(event_data['user']),
      user_email: @user_info.email(event_data['user']),
      channel_id: event_data['channel'],
      team_id: team_id,
      mark_all_out: @mark_all_out
    }
  end

  def respond(bot_answer, team_id, user_id, channel = user_id)
    @response.send(bot_answer, team_id, channel)
  end
end
