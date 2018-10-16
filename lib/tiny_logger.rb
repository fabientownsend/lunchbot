require 'logglier'

class Logger
  def self.alert(exception)
    return if ENV['RACK_ENV'] != 'production'

    Raven.capture_exception(exception)
  end

  def self.test_alert(content)
    return if ENV['RACK_ENV'] != 'production'

    exception = content[:exception]
    message = content[:message]

    Raven.capture_message(message) if message
    Raven.capture_exception(exception) if exception
  end

  def self.info(message)
    return if ENV['RACK_ENV'] != 'production'

    logger = Logglier.new(ENV['LOGGLIER_URL'], :threaded => true)
    logger.info(message)
  end
end
