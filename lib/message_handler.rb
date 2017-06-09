require 'alert_foreman'
require 'foreman_messager'
require 'mark_all_out'
require 'request_parser'
require 'response'
require 'user_info_provider'

class MessageHandler
  def initialize(args = {})
    @mark_all_out = args[:mark_all_out] || MarkAllOut.new
    @request_parser = RequestParser.new
    if args[:response]
      @response = args[:response] 
    else 
      @response = Response.new
      @response.setup
    end
    @user_info = args[:user_info_provider] || UserInfoProvider.new
    @foreman_messager = ForemanMessager.new
    @alert = AlertForeman.new(@foremanMessager)
  end

  def keep_alive(team_id, event_data)
    @alive = true
    respond("ping", team_id, event_data['user'], event_data['channel'])
    sleep 600
    keep_alive(team_id, event_data)
  end

  def handle(team_id, event_data)
    @foreman_messager.update_team_id(team_id)
    returned_command = @request_parser.parse(format_data(team_id, event_data))
    deal_with_command(returned_command, team_id, event_data) unless returned_command.nil?
    Thread.new {keep_alive(team_id, event_data)} if not @alive
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
      mark_all_out: @mark_all_out,
      alert: @alert
    }
  end

  def respond(bot_answer, team_id, user_id, channel = user_id)
    @response.send(bot_answer, team_id, channel)
  end
end
