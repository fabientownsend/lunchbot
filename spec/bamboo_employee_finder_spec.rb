require 'bamboo_employee_finder'

RSpec.describe BambooEmployeeFinder do
  let (:fake_data_slack) {[{user_id: "id", email: "email"}]}
  let (:fake_data_bamboo) {[{"workEmail" => "email"}]}

  it "can find a user with their slack_id" do
    user_finder = BambooEmployeeFinder.new(fake_data_slack, fake_data_bamboo)
    expect(user_finder.find_employee("id")).to eq(true)
  end
end
