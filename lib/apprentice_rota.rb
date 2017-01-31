class ApprenticeRota
  attr_reader :rota

  def initialize(apprentices)
    @rota = apprentices
  end

  def foreman()
    @rota.first
  end

  def foremanName()
    foreman().at(1)
  end

  def foremanID()
    foreman().at(0)
  end

  def notify_new_foreman()
    response = Response.new
  end

  def rotate()
    foreman_name = foremanName()
    foreman_id = foremanID()
    @rota.delete(foreman_id)
    @rota[foreman_id] = foreman_name
  end

  def rota()
    @rota
  end
end
