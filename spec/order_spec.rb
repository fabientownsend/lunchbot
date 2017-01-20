require 'spec_helper'
require_relative '../lib/order'

RSpec.describe Order do
  it "stores users lunch order" do
    order = Order.new("Will", "food", "id")
    expect(order.lunch).to eq("food")
    expect(order.user_name).to eq("Will")
    expect(order.user_id).to eq("id")
  end
end
