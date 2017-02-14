require 'commands/foreman/remove_apprentice'
require 'models/apprentice'

RSpec.describe RemoveApprentice do
  it "applies to the command remove apprentice" do
    remove_apprentice = RemoveApprentice.new
    result = remove_apprentice.applies_to("remove apprentice")
    expect(result).to be true
  end

  it "remove apprentice isn't case sensitive" do
    remove_apprentice = RemoveApprentice.new
    result = remove_apprentice.applies_to("Remove Apprentice")
    expect(result).to be true
  end

  it "remove apprentice isn't space sensitive" do
    remove_apprentice = RemoveApprentice.new
    result = remove_apprentice.applies_to("  remove apprentice  ")
    expect(result).to be true
  end

  it "doesn't do anything when remove someone that doesn't exist" do
    remove_foreman(id: "id two", name: "fabien")

    expect(Apprentice.count).to eq(0)
  end

  it "removes apprentice from the database when the command is run" do
    Helper.add_foreman(id: "id two", name: "fabien")

    remove_foreman(id: "id two", name: "fabien")

    expect(Apprentice.count).to eq(0)
  end

  it "removes the correct apprentice" do
    Helper.add_foreman(id: "id one", name: "will")
    Helper.add_foreman(id: "id two", name: "fabien")

    remove_foreman(id: "id two", name: "fabien")

    expect(Apprentice.count).to eq(1)
    expect(Apprentice.last(slack_id: "id two")).to be(nil)
  end

  it "return a message when the person has been removed" do
    Helper.add_foreman(id: "id two", name: "fabien")

    response = remove_foreman(id: "id two", name: "fabien")

    expect(response).to eq("fabien has been removed from apprentices.")
  end

  it "message that it's not an apprentice when user no found in database" do
    response = remove_foreman(id: "id two", name: "fabien")

    expect(response).to eq("fabien is not an apprentice!")
  end

  private

  def remove_foreman(data)
    id = data[:id]
    name = data[:name]

    remove_apprentice = RemoveApprentice.new
    remove_apprentice.prepare(user_id: id, user_name: name)
    remove_apprentice.run
  end
end
