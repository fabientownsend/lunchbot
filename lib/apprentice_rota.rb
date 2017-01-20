class ApprenticeRota
  attr_reader :rota

  def initialize(apprentices)
    @rota = apprentices
  end

  def foreman()
    @rota.first
  end

  def rotate()
    current_foreman = foreman()
    @rota.delete(current_foreman.at(0))
    @rota[current_foreman.at(0)] = current_foreman.at(1)
  end

  def rota()
    @rota
  end
end
