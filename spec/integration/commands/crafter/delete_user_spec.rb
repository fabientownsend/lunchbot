# typed: false
require 'commands/crafter/delete_user'

RSpec.describe Commands::DeleteUser do
  let(:command) { Commands::DeleteUser.new }

  it "applies to the command delete user" do
    result = command.applies_to?(user_message: "delete user")
    expect(result).to eq(true)
  end

  it "returns true if message starts with delete user" do
    expect(command.applies_to?(user_message: "delete user: Fabien")).to eq(true)
  end

  it "returns false is message doesn't start with delete user" do
    expect(command.applies_to?(user_message: "Hi Fabien")).to eq(false)
  end

  it "extracts user name Fabien from user message " do
    user_name = "Fabien Townsend"

    fake_data_from_slack = {
      user_message: "delete user: #{user_name}",
    }

    expect(command.prepare(fake_data_from_slack)).to eq(user_name)
  end

  it "extacts user name Katerina from user message " do
    user_name = "Katerina Georgiou"
    fake_data_from_slack = {
      user_message: "delete user: #{user_name}",
    }

    expect(command.prepare(fake_data_from_slack)).to eq(user_name)
  end

  it "deletes user from the database" do
    fake_data_from_slack = {
      user_message: "delete user: Will",
    }

    command.prepare(fake_data_from_slack)

    expect { command.run }.to change(User, :count).by(-1)
  end

  it "return success message when the user was deleted" do
    fake_data_from_slack = {
      user_message: "delete user: Will",
    }

    command.prepare(fake_data_from_slack)
    message = command.run

    expect(message).to eq("Will has been removed.")
  end
end
