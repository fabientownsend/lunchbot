require "add_apprentice"

RSpec.describe AddApprentice do
  let(:fake_data) {{user_id: "id", user_name: "Will"}}
  let(:fake_data2) {{user_id: "id2", user_name: "Will2"}}

  it "adds apprentice to the database when the command is run" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data)
    add_apprentice.run()
    expect(Apprentice.count).to eq(1)
    expect(Apprentice.last.slack_id).to eq("id")
  end

  it "adds two different apprentices to the database when the command is run by two different people" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data)
    add_apprentice.run()

    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data2)
    add_apprentice.run()

    expect(Apprentice.count).to eq(2)
    expect(Apprentice.last.slack_id).to eq("id2")
    expect(Apprentice.first.slack_id).to eq("id")
  end

  it "can not add the same apprentice twice" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data)
    add_apprentice.run()

    add_apprentice = AddApprentice.new
    add_apprentice.prepare(fake_data)
    add_apprentice.run()

    expect(Apprentice.count).to eq(1)
  end
end
