require 'commands/foreman/add_apprentice'
require 'models/apprentice'
require 'models/crafter'

RSpec.describe Commands::AddApprentice do
  let(:foreman) { Commands::AddApprentice.new }

  it "applies the command when the message is not stiped and lowercase" do
    response = foreman.applies_to?(user_message: "  Add apPrentice  ")

    expect(response).to be true
  end

  it "add a foreman to the database" do
    Crafter.create(user_name: "will", user_id: "id", office: "london")

    foreman.prepare(user_id: "id", user_name: "will")
    foreman.run

    expect(Apprentice.last.user_name).to eq("will")
    expect(Apprentice.last.slack_id).to eq("id")
  end

  it "returns a successful message when an apprentice is added" do
    Crafter.create(user_name: "will", user_id: "id", office: "london")

    foreman.prepare(user_id: "id", user_name: "will")

    expect(foreman.run).to eq("will has been added to apprentices.")
  end

  it "returns an error message when the apprentice is already registered" do
    Crafter.create(user_name: "will", user_id: "id", office: "london")

    foreman.prepare(user_id: "id", user_name: "will")
    foreman.run
    foreman.prepare(user_id: "id", user_name: "will")

    expect(foreman.run).to eq("will is already in the database.")
  end
end
