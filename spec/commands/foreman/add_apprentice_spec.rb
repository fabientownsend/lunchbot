require 'commands/foreman/add_apprentice'
require 'models/apprentice'

RSpec.describe Commands::AddApprentice do
  let(:add_apprentice) { Commands::AddApprentice.new }

  it "add a foreman to the database" do
    Helper.add_foreman(id: "id", name: "will")

    expect(Apprentice.last.user_name).to eq("will")
    expect(Apprentice.last.slack_id).to eq("id")
  end

  it "add two different foreman" do
    Helper.add_foreman(id: "id one", name: "will")
    Helper.add_foreman(id: "id two", name: "fabien")

    expect(Apprentice.last(slack_id: "id one").user_name).to eq("will")
    expect(Apprentice.last(slack_id: "id two").user_name).to eq("fabien")
  end

  it "can not add two foreman with the same id" do
    Helper.add_foreman(id: "id one", name: "will")
    Helper.add_foreman(id: "id one", name: "fabien")

    expect(Apprentice.count).to eq(1)
  end

  it "return a message when foreman already exist" do
    Helper.add_foreman(id: "id one", name: "will")
    response = Helper.add_foreman(id: "id one", name: "fabien")

    expect(response).to eq("fabien is already in the database.")
  end

  it "return a message when foreman added" do
    response = Helper.add_foreman(id: "id one", name: "will")

    expect(response).to eq("will has been added to apprentices.")
  end

  it "return true when it's a valid command" do
    response = add_apprentice.applies_to({user_message: "add apprentice"})

    expect(response).to be true
  end

  it "isn't case sensitive" do
    response = add_apprentice.applies_to({user_message: "Add apPrentice"})

    expect(response).to be true
  end

  it "isn't spaces sensitive" do
    response = add_apprentice.applies_to({user_message: "  Add apPrentice  "})

    expect(response).to be true
  end
end
