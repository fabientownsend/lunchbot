# typed: false
require 'commands/foreman/set_foreman'

RSpec.describe Commands::SetForeman do
  let(:command) { Commands::SetForeman.new }
  let(:request) do
    {
      user_id: "id",
      user_name: "name",
      user_message: "foreman: <@w_id>",
    }
  end

  before(:each) do
    create_user("Fabien", "f_id")
    create_user("Andrea", "a_id")
    create_user("Will", "w_id")
  end

  it "applies to request" do
    expect(command.applies_to?(request)).to eql true
  end

  it "respond with error message if user not found" do
    User.create(user_name: "name", user_id: "id", office: "london")

    command.prepare(
      user_id: "id",
      user_name: "name",
      user_message: "foreman: <@unknown_user>"
    )

    expect(command.run).to eq("User not found.")
  end

  it "set the foreman only if the target user belongs to the same office as the requester" do
    User.create(user_name: "name", user_id: "id", office: "london")
    command.prepare(request)
    expect(command.run).to eq("<@w_id> is now the foreman!")
  end

  it "does not set foreman if user not found in the same office" do
    User.create(user_name: "name", user_id: "id", office: "new york")
    command.prepare(request)
    message = "User must belong to the same office as you."
    expect(command.run).to eq(message)
  end

  private

  def create_user(name, id)
    User.new(
      user_name: name,
      slack_id: id,
      office: 'london'
    ).save
  end
end
