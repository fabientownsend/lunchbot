class FakeUserInfoProvider
  def initialize
    @names = %w(Fabien Will)
  end

  def real_name(_user_id)
    @names.reverse!.first
  end

  def email(_user_id)
    "email@email.com"
  end
end
