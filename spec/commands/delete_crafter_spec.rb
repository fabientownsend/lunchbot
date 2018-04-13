require 'commands/delete_crafter'

RSpec.describe Commands::DeleteCrafter do
  it "applies to the command remove crafter" do
    delete_crafter = Commands::DeleteCrafter.new

    result = delete_crafter.applies_to("delete crafter")
    expect(result).to eq(true)
  end

  it "returns true if message starts with delete crafter" do
    delete_crafter = Commands::DeleteCrafter.new
    expect(delete_crafter.applies_to("delete crafter Fabien")).to eq(true)
  end

  it "returns false is message doesn't start with delete crafter" do
    delete_crafter = Commands::DeleteCrafter.new
    expect(delete_crafter.applies_to("Hi Fabien")).to eq(false)
  end

  it "extacts crafter name Fabien from user message " do
    delete_crafter = Commands::DeleteCrafter.new
    crafter_name = "Fabien Townsend"

    fake_data_from_slack = {
      user_message: "delete crafter #{crafter_name}",
    }

    expect(delete_crafter.prepare(fake_data_from_slack)).to eq(crafter_name)
  end

  it "extacts crafter name Katerina from user message " do
    delete_crafter = Commands::DeleteCrafter.new
    crafter_name = "Katerina Georgiou"
    fake_data_from_slack = {
      user_message: "delete crafter #{crafter_name}",
    }

    expect(delete_crafter.prepare(fake_data_from_slack)).to eq(crafter_name)
  end

  it "deletes cafter name from the database" do
    delete_crafter = Commands::DeleteCrafter.new
    fake_data_from_slack = {
      user_message: "delete crafter Will",
    }

    delete_crafter.prepare(fake_data_from_slack)
    delete_crafter.run

    expect(Crafter.all.size).to eq(1)
  end

  it "return succes message when the crafter was deleted" do
    delete_crafter = Commands::DeleteCrafter.new
    fake_data_from_slack = {
      user_message: "delete crafter Will",
    }

    delete_crafter.prepare(fake_data_from_slack)
    message = delete_crafter.run

    expect(message).to eq("Will has been removed.")
  end
end
