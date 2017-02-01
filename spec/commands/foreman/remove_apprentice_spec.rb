require 'commands/foreman/remove_apprentice'
require 'models/apprentice'
require 'spec_helper'

RSpec.describe RemoveApprentice do
  it "removes apprentice from the database when the command is run" do
    Helper.add_foreman({id: "id two", name: "fabien"})

    remove_foreman({id: "id two", name: "fabien"})

    expect(Apprentice.count).to eq(0)
  end

  it "removes the correct apprentice" do
    Helper.add_foreman({id: "id one", name: "will"})
    Helper.add_foreman({id: "id two", name: "fabien"})

    remove_foreman({id: "id two", name: "fabien"})

    expect(Apprentice.count).to eq(1)
    expect(Apprentice.last(:slack_id => "id two")).to be(nil)
  end

  private

  def remove_foreman(data)
    id = data[:id]
    name = data[:name]

    remove_apprentice = RemoveApprentice.new
    remove_apprentice.prepare({user_id: id, user_name: name})
    remove_apprentice.run
  end
end
