require 'command_info'

class Help
  include CommandInfo

  def applies_to(request)
    request == "help"
  end

  def prepare(data)
  end

  def run
    all_command_info
  end
end
