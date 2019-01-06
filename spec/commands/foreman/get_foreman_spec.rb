require 'commands/foreman/get_foreman'

RSpec.describe Commands::GetForeman do
  let(:command) { Commands::GetForeman.new }

  it "applies the command when the message is not striped and lowercase" do
    expect(command.applies_to?(user_message: "  foreman?  ")).to be true
  end

  it "return a message when no foreman found" do
    User.create(user_name: "will", user_id: "id one", office: "london")

    command.prepare(user_id: "id one")

    expect(command.run).to eq("There are no foreman!")
  end

  it "gets the foreman who is in the same office as the requester" do
    User.create(user_name: "pomme de terre", user_id: "id one", office: "london")
    User.create(user_name: "will", user_id: "id two", office: "london")
    User.set_as_foreman("id two", "london")

    command.prepare(user_id: "id one")
    response = command.run

    expect(response).to eq("The foreman for this week is will")
  end

  it "does not find a foreman when no foreman for an office" do
    User.create(user_name: "billy", user_id: "id one", office: "london")
    User.create(user_name: "bob", user_id: "id two", office: "new york")
    User.set_as_foreman("id two", "new york")

    command.prepare(user_id: "id one")
    response = command.run

    expect(response).to eq("There are no foreman!")
  end
end
