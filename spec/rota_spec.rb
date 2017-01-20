require 'spec_helper'
require_relative '../lib/apprentice_rota'

RSpec.describe ApprenticeRota do
  it "knows the apprentices" do
    apprentices = {"user_id" => "Will"}
    apprentice_rota = ApprenticeRota.new(apprentices)
    rota = apprentice_rota.rota()
    expect(rota["user_id"]).to eq("Will")
  end

  it "knows the foreman" do
    apprentices = {"user_id" => "Will", "user_id2" => "Fabien"}
    apprentice_rota = ApprenticeRota.new(apprentices)
    foreman = apprentice_rota.foreman()
    expect(foreman).to eq(["user_id", "Will"])
  end

  it "knows the foreman after rotation" do
    apprentices = {"user_id" => "Will", "user_id2" => "Fabien"}
    apprentice_rota = ApprenticeRota.new(apprentices)
    apprentice_rota.rotate()
    foreman = apprentice_rota.foreman()
    expect(foreman).to eq(["user_id2", "Fabien"])
  end
end
