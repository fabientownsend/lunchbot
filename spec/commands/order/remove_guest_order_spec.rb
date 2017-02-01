require 'commands/order/remove_guest_order'
require 'models/order'
require 'spec_helper'

RSpec.describe RemoveGuestOrder do
  let (:remove_guest_order) { RemoveGuestOrder.new }

  it "do nothing when the user name doesn't exist" do
    response = remove_guest("James Smith")

    expect(response).to eq("james smith doesn't exist!")
  end

  it "remove a guest" do
    Helper.order_guest({name: "james smith", meal: "burger"})
    Helper.order_guest({name: "jean bon", meal: "burger"})

    response = remove_guest("james smith")

    expect(Order.last(:user_name => "james smith")).to be(nil)
    expect(response).to eq("james smith removed")
  end

  it "isn't case sensitive" do
    Helper.order_guest({name: "james smith", meal: "burger"})
    Helper.order_guest({name: "jean bon", meal: "burger"})

    response = remove_guest("James Smith")

    expect(Order.last(:user_name => "james smith")).to be(nil)
    expect(response).to eq("james smith removed")
  end

  it "isn't extra space sensitive" do
    Helper.order_guest({name: "james smith", meal: "burger"})
    Helper.order_guest({name: "jean bon", meal: "burger"})

    response = remove_guest("  James Smith  ")

    expect(response).to eq("james smith removed")
  end

  it "doesn't remove a crafter" do
    Helper.order_guest({name: "james smith", meal: "burger"})
    Helper.order_guest({name: "jean bon", meal: "burger"})
    Helper.order({user_id: "asdf", user_name: "will", user_message: "burger"})

    response = remove_guest("will")

    expect(Order.last(:user_name => "will")).not_to be(nil)
    expect(response).to eq("will isn't a guest!")
  end

  private

  def remove_guest(name)
    name.downcase
    remove_guest_order.prepare({user_message: "remove guest: #{name}"})
    remove_guest_order.run
  end
end
