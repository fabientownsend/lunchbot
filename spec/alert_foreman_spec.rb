require 'alert_foreman'

RSpec.describe AlertForeman do
  let(:fake_foreman_messager) { FakeForemanMessager.new }
  let(:alert) { AlertForeman.new(fake_foreman_messager) }

  it "sends a empty message by default" do
    alert.send
    expect(fake_foreman_messager.message).to eq("Something wrong is happening")
  end

  it "alrt without message" do
    alert.from(:order).send

    expect(fake_foreman_messager.message) .to eq(
      "Something wrong is happening with the order"
    )
  end

  it "sends a default title when empty" do
    alert.message("help").send

    expect(fake_foreman_messager.message) .to eq(
      "Something wrong is happening\nhelp"
    )
  end

  it "sends a custom title" do
    alert.message("help").from(:order).send

    expect(fake_foreman_messager.message) .to eq(
      "Something wrong is happening with the order\nhelp"
    )
  end

  class FakeForemanMessager
    attr_reader :message

    def send(message)
      @message = message
    end
  end
end
