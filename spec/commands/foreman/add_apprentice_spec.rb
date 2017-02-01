require 'commands/foreman/add_apprentice'
require 'models/apprentice'
require 'spec_helper'

RSpec.describe AddApprentice do
  it "add a foreman to the database" do
    Helper.add_foreman({id: "id", name: "will"})

    expect(Apprentice.last.user_name).to eq("will")
    expect(Apprentice.last.slack_id).to eq("id")
  end

  it "adds two different apprentices to the database when the command is run by two different people" do
    Helper.add_foreman({id: "id one", name: "will"})
    Helper.add_foreman({id: "id two", name: "fabien"})

    expect(Apprentice.last(:slack_id => "id one").user_name).to eq("will")
    expect(Apprentice.last(:slack_id => "id two").user_name).to eq("fabien")
  end

  it "can not add the same apprentice twice" do
    Helper.add_foreman({id: "id one", name: "will"})
    Helper.add_foreman({id: "id one", name: "will"})

    expect(Apprentice.count).to eq(1)
  end
end
