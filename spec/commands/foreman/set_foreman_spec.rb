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
    create_apprentice("Fabien", "f_id")
    create_apprentice("Andrea", "a_id")
    create_apprentice("Will", "w_id")
  end

  it "respond with error message if user not found" do
    User.create(user_name: "name", user_id: "id", office: "london")
    set_foreman.prepare(
      user_id: "id",
      user_name: "name",
      user_message: "set foreman: <@id>"
    )
    expect(set_foreman.run).to eq("That person is not an apprentice!")
  end

  it "set foreman if belongs to the same office than requester" do
    User.create(user_name: "name", user_id: "id", office: "london")
    set_foreman.prepare(fake_data)
    expect(set_foreman.run).to eq("<@w_id> is now the foreman!")
  end

  it "does not set foreman if user not found in the same office" do
    User.create(user_name: "name", user_id: "id", office: "new york")
    set_foreman.prepare(fake_data)
    expect(set_foreman.run).to eq("That person is not an apprentice!")
  end

  private

  def create_apprentice(name, id)
    Apprentice.new(
      user_name: name,
      slack_id: id,
      office: 'london'
    ).save
  end
end
