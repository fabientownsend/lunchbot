# typed: true
class BambooCache
  def whos_out
    @whos_out_data
  end

  sig { params(bla: String).returns(TrueClass) }
  def lol(bla)
    true
  end

  def employees
    @employees_data
  end

  def store_whos_out(data)
    @whos_out_last_cache = Time.now.day
    @whos_out_data = data
  end

  def store_employees(data)
    @employees_last_cache = Time.now.day
    @employees_data = data
  end

  def whos_out_needs_cache?
    Time.now.day != @whos_out_last_cache
  end

  def employees_needs_cache?
    Time.now.day != @employees_last_cache
  end
end
