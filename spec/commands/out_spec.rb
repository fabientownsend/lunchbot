require 'commands/out'

RSpec.describe Out do
  it "should place an out order when command is run" do
    out = Out.new
    out.prepare({user_id: "id", user_name: "Will"})
    out.run

    expect(Order.last.lunch).to eq("out")
    expect(Order.last.user_id).to eq("id")
  end
end
