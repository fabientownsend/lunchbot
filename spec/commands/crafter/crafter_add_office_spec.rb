require 'commands/crafter/add_office'
require 'models/apprentice'

RSpec.describe Commands::AddOffice do
  it "applies the command when required" do
    add_office_command = Commands::AddOffice.new

    expect(add_office_command.applies_to(
      user_message: "office: london",
      user_name: "Fabien Townsend"
    )).to eq(true)
  end

  it "adds the office to the user" do
    Crafter.new(
      :user_name => "Fabien",
      :slack_id => "1234",
      :email => "fabien@adsak.com"
    ).save
    add_office_command = Commands::AddOffice.new

    add_office_command.prepare(user_message: "office: London", user_id: "1234")
    response = add_office_command.run

    crafter = Crafter.last(:slack_id => "1234")

    expect(crafter.office).to eq("london")
    expect(response).to eq("You were added to the office: london")
  end

  it "does not add office is not available" do
    Crafter.new(
      :user_name => "Fabien",
      :slack_id => "1234",
      :email => "fabien@adsak.com"
    ).save
    add_office_command = Commands::AddOffice.new

    add_office_command.prepare(user_message: "office: random office", user_id: "1234")
    response = add_office_command.run

    expect(response).to eq("The office available are: London, Madisson")
  end

  it "does add office to apprentice if this person is an apprentice too" do
    Crafter.new(
      :user_name => "Fabien",
      :slack_id => "1234",
      :email => "fabien@adsak.com"
    ).save
    Apprentice.new(
      user_name: "Fabien Townsend",
      slack_id: "1234"
    ).save
    add_office_command = Commands::AddOffice.new

    add_office_command.prepare(user_message: "london", user_id: "1234")
    add_office_command.run

    expect(Apprentice.profile("1234").office).to eq("london")
  end

  it "does nothing if crafter or apprentice does no exist" do
    add_office_command = Commands::AddOffice.new

    add_office_command.prepare(user_message: "london", user_id: "does not exist")
    result = add_office_command.run

    expect(result).to eq("")
  end
end
