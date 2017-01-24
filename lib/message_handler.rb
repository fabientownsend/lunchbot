require 'request_parser'
require 'response'

class MessageHandler
  def initialize(response = Response.new)
    @response = response
    @request_parser = RequestParser.new()
  end

  def handle(team_id, event_data)
    data = {
      user_message: event_data['text'],
      user_id: event_data['user'],
      user_name: event_data['name']
    }

    returned_command = @request_parser.parse(data)
    returned_command.run()

    if returned_command.response?
      respond(returned_command.response, team_id, event_data['user'], event_data['channel'])
    end
  end

  def respond(bot_answer, team_id, user_id, channel = user_id)
    @response.send(bot_answer, team_id, channel)
  end
end
