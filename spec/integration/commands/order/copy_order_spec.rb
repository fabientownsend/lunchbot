require 'commands/order/copy_order'
require 'days'

RSpec.describe Commands::CopyOrder do
  let(:id_user_reference) { "id_one" }
  let(:id_user_which_copy) { "id_two" }

  it "copy the order of the person specified" do
    User.create(
      user_id: id_user_reference,
      user_name: "Fabien",
      office: "london"
    )

    Helper.order(
      user_id: id_user_reference,
      user_name: "Fabien",
      user_message: "sandwhich",
      date: Days.monday
    )

    response = copy_order_from(id_user_reference, id_user_which_copy)

    expect(response).to eq("Will just copied <@id_one>'s order!")
    expect(Order.count).to eq(2)
    expect(Order.last(user_id: id_user_which_copy).lunch).to eq("Sandwhich")
  end

  it "know if a user specified is invalid" do
    response = copy_order_from(id_user_reference, id_user_which_copy)

    expect(response).to eq("That user does not have an order!")
  end

  it "update a users order to the person they are copying" do
    User.create(
      user_id: id_user_reference,
      user_name: "Fabien",
      office: "london"
    )

    Helper.order(
      user_id: id_user_reference,
      user_name: "Fabien",
      user_message: "sandwhich",
      date: Days.monday
    )

    Helper.order(
      user_id: id_user_which_copy,
      user_name: "Will",
      user_message: "fish",
      date: Days.monday
    )

    response = copy_order_from(id_user_reference, id_user_which_copy)

    expect(Order.count).to eq(2)
    expect(Order.last(user_id: id_user_which_copy).lunch).to eq("Sandwhich")
    expect(response).to eq("Will just copied <@id_one>'s order!")
  end

  it "can't copy a order from a previous week" do
    Helper.order_previous_monday(
      user_id: id_user_reference,
      user_name: "Will",
      user_message: "fish"
    )

    response = copy_order_from(id_user_reference, id_user_which_copy)

    expect(response).to eq("That user does not have an order!")
  end

  def copy_order_from(id_user_reference, id_user_which_copy)
    fake = {
      user_id: id_user_which_copy,
      user_name: "Will",
      user_message: "copy order: <@#{id_user_reference}>",
    }

    copy_order = Commands::CopyOrder.new
    copy_order.prepare(fake)
    copy_order.run
  end
end
