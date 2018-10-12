require 'commands/crafter/add_office'

RSpec.describe Commands::AddOffice do
  it "applies the command when required" do
    add_office_command = Commands::AddOffice.new

    expect(add_office_command.applies_to(
      user_message: "office: london",
      user_name: "Fabien Townsend"
    )).to eq(true)
  end

  it "adds the office to the user" do
    add_office_command = Commands::AddOffice.new
    add_office_command.prepare(user_message: "office: london", user_id: "1234")

    new_user = Crafter.new(
      :user_name => "Fabien",
      :slack_id => "1234",
      :email => "fabien@adsak.com"
    )
    new_user.save

    add_office_command.run

    crafter = Crafter.last(:slack_id => "1234")
    expect(crafter.office).to eq("london")
  end
end
