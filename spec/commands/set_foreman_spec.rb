require 'commands/set_foreman'

RSpec.describe SetForeman do
  let (:fake_data) {{user_id: "id", user_name: "name", user_message: "set foreman: <@w_id>"}}

  before(:each) do
    apprentice = Apprentice.new(
      :user_name => "Fabien",
      :slack_id => "f_id",
    )
    apprentice.save

    apprentice2 = Apprentice.new(
      :user_name => "Andrea",
      :slack_id => "a_id",
    )
    apprentice2.save

    apprentice3 = Apprentice.new(
      :user_name => "Will",
      :slack_id => "w_id",
    )
    apprentice3.save
  end

  it "should respond invalid if its not a valid userid" do
    set_foreman = SetForeman.new
    set_foreman.prepare({user_id: "id", user_name: "name", user_message: "set foreman: <@id>"})
    expect(set_foreman.run).to eq("That person is not an apprentice!")
  end

  it "should notify the new foreman" do
    set_foreman = SetForeman.new
    set_foreman.prepare(fake_data)
    expect(set_foreman.run).to eq("<@w_id> is now the foreman!")   
  end

  it "should make the userid given first in the database" do
    set_foreman = SetForeman.new
    set_foreman.prepare(fake_data)
    set_foreman.run
    expect(Apprentice.first.slack_id).to eq("w_id")
  end

  it "should shuffle second apprentice down by one" do
    set_foreman = SetForeman.new
    set_foreman.prepare(fake_data)
    set_foreman.run
    expect(Apprentice.last.slack_id).to eq("a_id")
  end
end
