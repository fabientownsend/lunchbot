class Ping
  def applies_to(request)
    request == "ping"
  end

  def prepare(data)

  end

  def run
    "ping"
  end
end
