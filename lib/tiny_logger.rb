require 'logglier'

class Logger
  def self.alert(exception)
    Raven.capture_exception(exception)
  end

  def self.info(message)
    #logger = Logglier.new(ENV['LOGGLIER_URL'], :threaded => true)
    #logger.info('[INFO] #{message}')
  end
end
