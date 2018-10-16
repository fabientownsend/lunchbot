require 'tiny_logger'

Dir["#{File.dirname(__FILE__)}/commands/**/*.rb"].each { |file| require file }

class RequestParser
  def parse(data)
    klass(requested_command(data)).prepare(data)
  end

  def requested_command(data)
    Commands.constants.detect { |command| klass(command).requested?(data) }
  end

  def klass(command)
    return if command.nil?
    Logger.info("CREATE NEW INSTANCE #{command}")
    @kommand = Object.const_get("Commands::#{command}").new
    self
  rescue StandardError => error
    Logger.alert(error)
  end

  def requested?(data)
    @kommand.applies_to(data)
  rescue StandardError => error
    Logger.alert(error)
  end

  def prepare(data)
    Logger.info("COMMAND PREPARE: #{@kommand} WITH #{data}")
    @kommand.prepare(data)
    Logger.info("COMMAND PREPARED")
    @kommand
  end
end
