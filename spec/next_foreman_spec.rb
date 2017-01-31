require 'next_foreman_command'
require 'add_apprentice'

RSpec.describe NextForeman do
  it "nextforeman changes to the new apprentice on run" do
    add_apprentice = AddApprentice.new
    add_apprentice.prepare({user_name: "Will", slack_id: "id"})
    add_apprentice.run()

    add_apprentice = AddApprentice.new
    add_apprentice.prepare({user_name: "Fabien", slack_id: "id2"})
    add_apprentice.run()

    foreman_next = NextForeman.new
    foreman_next.run()
    expect(Apprentice.last.user_name).to eq("Fabien")
  end
end
