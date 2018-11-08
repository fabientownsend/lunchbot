require 'models/apprentice'

RSpec.describe Apprentice do
  it "does not set a foreman as current foreman by default" do
    Apprentice.create(user_id: "the id", office: "london")

    apprentice = Apprentice.profile("the id")

    expect(apprentice.is_foreman).to be false
  end

  it "sets person as a foreman" do
    Apprentice.create(user_id: "the id", office: "london")

    Apprentice.set_as_foreman("the id", "london")
    apprentice = Apprentice.profile("the id")

    expect(apprentice.is_foreman).to be true
  end

  it "says if user is a foreman" do
    Apprentice.create(user_id: "the id", office: "london")
    Apprentice.set_as_foreman("the id", "london")

    expect(Apprentice.foreman?("the id")).to be true
  end

  it "says if user is not a foreman" do
    Apprentice.create(user_id: "the id", office: "london")

    expect(Apprentice.foreman?("the id")).to be false
  end

  it "removes previous foreman if one was found" do
    Apprentice.create(user_id: "Margarette", office: "london")
    Apprentice.create(user_id: "Claudia", office: "london")

    Apprentice.set_as_foreman("Margarette", "london")
    apprentice_one = Apprentice.profile("Margarette")
    apprentice_two = Apprentice.profile("Claudia")

    expect(apprentice_one.is_foreman).to be true
    expect(apprentice_two.is_foreman).to be false

    Apprentice.set_as_foreman("Claudia", "london")
    apprentice_one = Apprentice.profile("Margarette")
    apprentice_two = Apprentice.profile("Claudia")

    expect(apprentice_one.is_foreman).to be false
    expect(apprentice_two.is_foreman).to be true
  end
end
