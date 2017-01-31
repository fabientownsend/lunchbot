require "commands/add_apprentice"
require "commands/remove_apprentice"

RSpec.describe RemoveApprentice do
  let(:fake_data) {{user_id: "id", user_name: "Will"}}
  let(:fake_data2) {{user_id: "id2", user_name: "Will2"}}

  it "removes apprentice from the database when the command is run" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data)
    add_apprentice.run()

    remove_apprentice = RemoveApprentice.new
    remove_apprentice.prepare(fake_data)
    remove_apprentice.run()

    expect(Apprentice.count).to eq(0)
  end

  it "removes the correct apprentice" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data)
    add_apprentice.run()

    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data2)
    add_apprentice.run()

    remove_apprentice = RemoveApprentice.new
    remove_apprentice.prepare(fake_data)
    remove_apprentice.run()

    expect(Apprentice.count).to eq(1)
    expect(Apprentice.first.slack_id).to eq("id2")
  end
end
