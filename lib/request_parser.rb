# typed: true
require 'tiny_logger'

Dir["#{File.dirname(__FILE__)}/commands/**/*.rb"].each { |file| require file }

class RequestParser
  def parse(data)
    klass(requested_command(data)).prepare(data)
  end

  def find_command?(data)
    requested_command(data) != nil
  end

  def requested_command(data)
    Commands.constants.detect { |command| klass(command).requested?(data) }
  end

  def klass(command)
    @kommand = Object.const_get("Commands::#{command}").new
    self
  end

  def requested?(data)
    @kommand.applies_to?(data)
  rescue StandardError => error
    Logger.alert(error)
  end

  def prepare(data)
    @kommand.prepare(data)
    @kommand
  end
end
