class Logger
  def self.alert(exception)
    Raven.capture_exception(exception)
  end

  def self.info(message)
    logger.info(message)
  end
end
