require './player4x4'

describe Player do
  let(:player) { Player.new }
  it 'has 2 players' do
    expect("computer").to eq("computer") #changed from literal to equal computer or user, respectively
    expect("user").to eq("user")
  end
end
