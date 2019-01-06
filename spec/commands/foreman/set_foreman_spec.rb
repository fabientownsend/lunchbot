require 'commands/foreman/set_foreman'

RSpec.describe Commands::SetForeman do
  let(:set_foreman) { Commands::SetForeman.new }
  let(:fake_data) do
    {
      user_id: "id",
      user_name: "name",
      user_message: "set foreman: <@w_id>",
    }
  end

  before(:each) do
    create_user("Fabien", "f_id")
    create_user("Andrea", "a_id")
    create_user("Will", "w_id")
  end

  it "respond with error message if user not found" do
    User.create(user_name: "name", user_id: "id", office: "london")

    set_foreman.prepare(
      user_id: "id",
      user_name: "name",
      user_message: "set foreman: <@unknown_user>"
    )

    expect(set_foreman.run).to eq("User not found.")
  end

  it "set the foreman only if the target user belongs to the same office as the requester" do
    User.create(user_name: "name", user_id: "id", office: "london")
    set_foreman.prepare(fake_data)
    expect(set_foreman.run).to eq("<@w_id> is now the foreman!")
  end

  it "does not set foreman if user not found in the same office" do
    User.create(user_name: "name", user_id: "id", office: "new york")
    set_foreman.prepare(fake_data)
    message = "User must belong to the same office as you."
    expect(set_foreman.run).to eq(message)
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
