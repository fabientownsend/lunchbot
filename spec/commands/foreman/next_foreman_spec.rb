require 'commands/foreman/next_foreman_command'
require 'commands/foreman/add_apprentice'

RSpec.describe NextForeman do
  it "nextforeman changes to the new apprentice on run" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare({user_name: "Will", user_id: "id"})
    add_apprentice.run()

    add_apprentice = AddApprentice.new
    add_apprentice.prepare({user_name: "Fabien", user_id: "id2"})
    add_apprentice.run()

    next_foreman = NextForeman.new
    next_foreman.run

    expect(Apprentice.count).to eq(2)
    expect(Apprentice.first.user_name).to eq("Fabien")
  end
end
