require 'commands/foreman/set_foreman'

RSpec.describe Commands::SetForeman do
  let(:set_foreman) { Commands::SetForeman.new }
  let(:fake_data) do
    {
      user_id: "id",
      user_name: "name",
      user_message: "set foreman: <@w_id>"
    }
  end

  before(:each) do
    create_apprentice("Fabien", "f_id")
    create_apprentice("Andrea", "a_id")
    create_apprentice("Will", "w_id")
  end

  it "should respond invalid if its not a valid userid" do
    set_foreman.prepare(
      user_id: "id",
      user_name: "name",
      user_message: "set foreman: <@id>"
    )
    expect(set_foreman.run).to eq("That person is not an apprentice!")
  end

  it "should notify the new foreman" do
    set_foreman.prepare(fake_data)
    expect(set_foreman.run).to eq("<@w_id> is now the foreman!")
  end

  it "should make the userid given first in the database" do
    set_foreman.prepare(fake_data)
    set_foreman.run
    expect(Apprentice.first.slack_id).to eq("w_id")
  end

  it "should shuffle second apprentice down by one" do
    set_foreman.prepare(fake_data)
    set_foreman.run
    expect(Apprentice.last.slack_id).to eq("a_id")
  end

  private

  def create_apprentice(name, id)
    apprentice = Apprentice.new(
      user_name: name,
      slack_id: id
    )
    apprentice.save
  end
end
