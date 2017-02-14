require 'out_checker'
require 'fake_slack_info'

class FakeBambooInfoProvider
  def whos_out
    [{ "employeeId" => "99", "end" => "2017-02-05", "start" => "2017-02-12" }]
  end

  def employees
    [{ "workEmail" => "email", "id" => "99" }]
  end
end

RSpec.describe OutChecker do
  let(:fake_data_slack) { [FakeSlackInfo.new] }
  let(:fake_info_provider) { FakeBambooInfoProvider.new }

  it "knows if a user is out on friday" do
    out_checker = OutChecker.new(fake_data_slack, fake_info_provider)
    expect(out_checker.is_out?("id")).to eq(true)
  end

  it "returns false if user is not out" do
    out_checker = OutChecker.new(fake_data_slack, fake_info_provider)
    expect(out_checker.is_out?("another_id")).to eq(false)
  end
end
