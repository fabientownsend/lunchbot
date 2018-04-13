class Logger
  def self.alert(exception)
    Raven.capture_exception(exception)
  end
end
