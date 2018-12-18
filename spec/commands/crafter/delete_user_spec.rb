require 'commands/crafter/delete_user'

RSpec.describe Commands::DeleteUser do
  it "applies to the command remove user" do
    command = Commands::DeleteUser.new

    result = command.applies_to?(user_message: "delete crafter")
    expect(result).to eq(true)
  end

  it "returns true if message starts with delete crafter" do
    command = Commands::DeleteUser.new
    expect(command.applies_to?(user_message: "delete crafter Fabien")).to eq(true)
  end

  it "returns false is message doesn't start with delete crafter" do
    command = Commands::DeleteUser.new
    expect(command.applies_to?(user_message: "Hi Fabien")).to eq(false)
  end

  it "extacts crafter name Fabien from user message " do
    command = Commands::DeleteUser.new
    user_name = "Fabien Townsend"

    fake_data_from_slack = {
      user_message: "delete crafter #{user_name}",
    }

    expect(command.prepare(fake_data_from_slack)).to eq(user_name)
  end

  it "extacts crafter name Katerina from user message " do
    command = Commands::DeleteUser.new
    user_name = "Katerina Georgiou"
    fake_data_from_slack = {
      user_message: "delete crafter #{user_name}",
    }

    expect(command.prepare(fake_data_from_slack)).to eq(user_name)
  end

  it "deletes cafter name from the database" do
    command = Commands::DeleteUser.new
    fake_data_from_slack = {
      user_message: "delete crafter Will",
    }

    command.prepare(fake_data_from_slack)
    command.run

    expect(User.all.size).to eq(1)
  end

  it "return succes message when the crafter was deleted" do
    command = Commands::DeleteUser.new
    fake_data_from_slack = {
      user_message: "delete crafter Will",
    }

    command.prepare(fake_data_from_slack)
    message = command.run

    expect(message).to eq("Will has been removed.")
  end
end
