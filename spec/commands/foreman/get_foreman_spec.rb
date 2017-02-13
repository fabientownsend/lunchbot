require 'commands/foreman/get_foreman'

RSpec.describe GetForeman do
  let (:foreman) { GetForeman.new }

  it "applies to a foreman command" do
    expect(foreman.applies_to("foreman")).to be true
  end

  it "freman comman isn't case sensitive" do
    expect(foreman.applies_to("Foreman")).to be true
  end

  it "freman comman isn't spaces sensitive" do
    expect(foreman.applies_to("  foreman  ")).to be true
  end

  it "return a message when no foreman found" do
    response = foreman.run

    expect(response).to eq("There are no apprentices!")
  end

  it "return the foreman of the week" do
    Helper.add_foreman({id: "id one", name: "will"})

    response = foreman.run

    expect(response).to eq("The foreman for this week is will")
  end
end
