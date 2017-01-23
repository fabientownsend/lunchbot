class ForemanCommand
  attr_reader :response

  def initialize(rota)
    @apprentice_rota = rota
  end

  def response?
    response
  end

  def run()
    @response = "The foreman for this week is #{@apprentice_rota.foremanName()}"
  end
end
