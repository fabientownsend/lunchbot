require 'bamboo_employee_finder'
require 'fake_slack_info'

RSpec.describe BambooEmployeeFinder do
  let(:fake_data_slack) { [FakeSlackInfo.new] }
  let(:fake_data_bamboo) { [{ "workEmail" => "email", "id" => "99" }] }

  it "can find a bamboo employeeId with a slack id" do
    user_finder = BambooEmployeeFinder.new(fake_data_slack, fake_data_bamboo)
    expect(user_finder.employee_id("id")).to eq("99")
  end

  it "returns user does not exist if the id given is invalid" do
    user_finder = BambooEmployeeFinder.new(fake_data_slack, fake_data_bamboo)
    expect(user_finder.employee_id("invalid_id")) .to eq(
      "User does not exist in the channel!"
    )
  end
end
