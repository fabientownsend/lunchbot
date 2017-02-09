require 'bamboo_employee_finder'

RSpec.describe BambooEmployeeFinder do
  let (:fake_data_slack) {[{user_id: "id", email: "email"}]}
  let (:fake_data_bamboo) {[{"workEmail" => "email", "employeeId" => "1"}]}

  it "can find a user with their slack_id" do
    user_finder = BambooEmployeeFinder.new(fake_data_slack, fake_data_bamboo)
    expect(user_finder.employee_id("id")).to eq("1")
  end
end
