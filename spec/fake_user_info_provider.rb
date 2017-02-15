class FakeUserInfoProvider
  def initialize(team_id)
    @names = ["Fabien", "Will"]
    @team_id = team_id
  end

  def real_name(user_id)
    @names.reverse!.first
  end

  def email(user_id)
    "email@email.com"
  end
end
