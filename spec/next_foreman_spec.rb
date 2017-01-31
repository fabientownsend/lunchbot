require 'next_foreman_command'
require 'fake_channel_info_provider'

RSpec.describe NextForeman do
  it "return all the person that didn't order" do
    apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
    foreman_next = NextForeman.new(apprentice_rota)
    foreman_next.run()
    expect(apprentice_rota.foremanName()).to eq("Fabien")
  end
end
