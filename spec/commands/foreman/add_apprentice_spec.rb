require 'commands/foreman/add_apprentice'
require 'models/apprentice'
require 'models/crafter'

RSpec.describe Commands::AddApprentice do
  let(:add_apprentice) { Commands::AddApprentice.new }

  it "applies the command when the emssage is not stiped and lowercase" do
    response = add_apprentice.applies_to?(user_message: "  Add apPrentice  ")

    expect(response).to be true
  end

  it "add a foreman to the database" do
    Crafter.create(user_name: "will", user_id: "id", office: "london")

    add_apprentice.prepare(user_id: "id", user_name: "will")
    add_apprentice.run

    expect(Apprentice.last.user_name).to eq("will")
    expect(Apprentice.last.slack_id).to eq("id")
  end

  it "returns a successful message when an apprentice is added" do
    Crafter.create(user_name: "will", user_id: "id", office: "london")

    add_apprentice.prepare(user_id: "id", user_name: "will")

    expect(add_apprentice.run).to eq("will has been added to apprentices.")
  end

  it "returns an error message when the apprentice is already registered" do
    Crafter.create(user_name: "will", user_id: "id", office: "london")

    add_apprentice.prepare(user_id: "id", user_name: "will")
    add_apprentice.run
    add_apprentice.prepare(user_id: "id", user_name: "will")

    expect(add_apprentice.run).to eq("will is already in the database.")
  end
end
