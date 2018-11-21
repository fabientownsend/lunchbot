require 'models/user'

RSpec.describe User do
  it "does not set a foreman as current foreman by default" do
    User.create(user_id: "the id", office: "london")

    user = User.profile("the id")

    expect(user.is_foreman).to be false
  end

  it "sets person as a foreman" do
    User.create(user_id: "the id", office: "london")
    User.set_as_foreman("the id", "london")

    user = User.profile("the id")

    expect(user.is_foreman).to be true
  end

  it "says if user is a foreman" do
    User.create(user_id: "the id", office: "london")
    User.set_as_foreman("the id", "london")

    expect(User.foreman?("the id")).to be true
  end

  it "says if user is not a foreman" do
    User.create(user_id: "the id", office: "london")

    expect(User.foreman?("the id")).to be false
  end

  it "removes previous foreman if one was found" do
    User.create(user_id: "Margarette", office: "london")
    User.create(user_id: "Claudia", office: "london")

    User.set_as_foreman("Margarette", "london")
    user_one = User.profile("Margarette")
    user_two = User.profile("Claudia")

    expect(user_one.is_foreman).to be true
    expect(user_two.is_foreman).to be false

    User.set_as_foreman("Claudia", "london")
    user_one = User.profile("Margarette")
    user_two = User.profile("Claudia")

    expect(user_one.is_foreman).to be false
    expect(user_two.is_foreman).to be true
  end
end
