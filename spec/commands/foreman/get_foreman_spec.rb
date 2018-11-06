require 'commands/foreman/get_foreman'

RSpec.describe Commands::GetForeman do
  let(:foreman) { Commands::GetForeman.new }

  it "applies the command when the message is not stiped and lowercase" do
    expect(foreman.applies_to?(user_message: "  foreman  ")).to be true
  end

  it "return a message when no foreman found" do
    Crafter.create(user_name: "will", user_id: "id one", office: "london")

    foreman.prepare(user_id: "id one")

    expect(foreman.run).to eq("There are no foreman!")
  end

  it "gets the forman who is in the same office than the requester" do
    Crafter.create(user_name: "pomme de terre", user_id: "id one", office: "london")
    Apprentice.create(user_name: "will", user_id: "id two", office: "london")

    foreman.prepare(user_id: "id one")
    response = foreman.run

    expect(response).to eq("The foreman for this week is will")
  end

  it "does not find a foreman when no foreman for an office" do
    Crafter.create(user_name: "billy", user_id: "id one", office: "london")
    Apprentice.create(user_name: "bob", user_id: "id two", office: "new york")

    foreman.prepare(user_id: "id one")
    response = foreman.run

    expect(response).to eq("There are no foreman!")
  end
end
