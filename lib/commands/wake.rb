class Wake
  def applies_to(request)
    request == "wake"
  end

  def prepare(data)
    
  end

  def run
    "Hello"
  end

end
