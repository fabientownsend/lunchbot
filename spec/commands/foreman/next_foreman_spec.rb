require 'commands/foreman/next_foreman_command'
require 'models/apprentice'

RSpec.describe NextForeman do
  let (:next_foreman) { NextForeman.new }

  it "apply to the command next foreman" do
    response = next_foreman.applies_to("next foreman")
    expect(response).to be true
  end

  it "isn't case sensitive" do
    response = next_foreman.applies_to("Next Foreman")
    expect(response).to be true
  end

  it "isn't space sensitive" do
    response = next_foreman.applies_to("  next foreman  ")
    expect(response).to be true
  end

  it "foreman remain the same when he is the only one" do
    Helper.add_foreman({id: "id one", name: "will"})

    expect(Apprentice.first.user_name).to eq("will")
    next_foreman.run
    expect(Apprentice.first.user_name).to eq("will")
  end

  it "set the second apprentice at the first position" do
    Helper.add_foreman({id: "id one", name: "will"})
    Helper.add_foreman({id: "id two", name: "fabien"})

    expect(Apprentice.first.user_name).to eq("will")
    next_foreman.run
    expect(Apprentice.first.user_name).to eq("fabien")
  end

  it "put the first apprentice to the last position" do
    Helper.add_foreman({id: "id one", name: "will"})
    Helper.add_foreman({id: "id two", name: "fabien"})

    expect(Apprentice.first.user_name).to eq("will")
    next_foreman.run
    expect(Apprentice.last.user_name).to eq("will")
  end

  it "said if it didn't found any apprentice" do
    response = next_foreman.run
    expect(response).to eq("There are no apprentices!")
  end

  it "return the new foreman" do
    Helper.add_foreman({id: "id one", name: "will"})
    response = next_foreman.run
    expect(response).to eq("The new foreman is <@id one>")
  end
end
