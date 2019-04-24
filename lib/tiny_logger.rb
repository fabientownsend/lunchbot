require 'honeycomb-beeline'
require 'logglier'

class Logger
  def self.alert(exception)
    return if ENV['RACK_ENV'] != 'production'

    Raven.capture_exception(exception)
  end

  def self.info(message)
    return if ENV['RACK_ENV'] != 'production'

    logger = Logglier.new(ENV['LOGGLIER_URL'], :threaded => true)
    logger.info(message)
  end

  def self.honey
    return if ENV['RACK_ENV'] != 'production'

    Honeycomb.add_field(ENV['RACK_ENV'], :greetee, "hello")
  end
end
