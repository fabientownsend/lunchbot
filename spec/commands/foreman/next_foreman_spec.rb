require 'commands/foreman/next_foreman_command'
require 'models/apprentice'
require 'spec_helper'

RSpec.describe NextForeman do
  it "nextforeman changes to the new apprentice on run" do
    next_foreman = NextForeman.new
    Helper.add_foreman({id: "id one", name: "will"})
    Helper.add_foreman({id: "id two", name: "fabien"})

    expect(Apprentice.first.user_name).to eq("will")
    next_foreman.run
    expect(Apprentice.first.user_name).to eq("fabien")
  end
end
