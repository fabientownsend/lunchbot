class FakeUserInfoProvider
  def initialize(email: "email@email.com", names: %w(Fabien Will))
    @email = email
    @names = names
  end

  def real_name(_user_id)
    @names.last
  end

  def email(_user_id)
    @email
  end
end
