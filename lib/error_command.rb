class ErrorCommand
  def run
  end

  def response?
    true
  end

  def response
    "This isn't a valid request"
  end
end
