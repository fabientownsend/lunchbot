require 'net/http'
require 'json'

class FakeUserInfoProvider
  def initialize
    @names = ["Fabien", "Will"]
  end

  def real_name(user_id, team_id)
    @names.reverse!.first
  end

  def email(user_id, team_id)
    "email@email.com"
  end
end
