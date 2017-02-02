require 'commands/copy_order'

RSpec.describe CopyOrder do
  before(:each) do
    order_to_copy = Order.new(
      :user_id => "id",
      :user_name => "Will",
      :lunch => "sandwhich",
      :date => Time.now
    )
    order_to_copy.save
  end

  let (:fake_data) {{user_id: "id2", user_name: "Will", user_message: 
  "copy order: <@id>"}}

  it "should copy the order of the person specified" do
    copy_order = CopyOrder.new
    copy_order.prepare(fake_data)
    copy_order.run
    
    expect(Order.count).to eq(2)
    expect(Order.last.lunch).to eq("sandwhich")
  end

  it "should know if a user specified is invalid" do
    copy_order = CopyOrder.new
    copy_order.prepare({user_id: "id", user_name: "Will", user_message: "order me: @lz"})
    expect(copy_order.run).to eq("That user does not have an order!")
  end

  it "should update a users order to the person they are copying" do
    existing_order = Order.new(
      :user_id => "id2",
      :user_name => "Will",
      :lunch => "fish",
      :date => Time.now
    )
    existing_order.save

    copy_order = CopyOrder.new
    copy_order.prepare(fake_data)
    copy_order.run
    
    expect(Order.count).to eq(2)
    expect(Order.last.lunch).to eq("sandwhich")
  end
end
