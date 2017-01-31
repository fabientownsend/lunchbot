class NextForeman
  def initialize(apprentice_rota)
    @apprentice_rota = apprentice_rota
  end

  def run()
    @apprentice_rota.rotate()
    "The new forman is <@#{@apprentice_rota.foremanID()}>"
  end

  def applies_to(request)
    request == "next foreman"
  end

  def prepare(data)
  end
end
