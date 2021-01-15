RSpec.describe Web::Controllers::Leaderboard::Index do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:repository) { PlayerRepository.new }

  before do
    repository.clear

    @player =
      repository.create(
        ett_name: 'luschenkiller',
        ett_id: 200_672,
        ett_elo: 1700,
        ett_wins: 20,
        ett_losses: 30,
        ett_rank: 1
      )
  end

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq(200)
  end

  it 'exposes all players' do
    action.call(params)
    expect(action.exposures[:players]).to eq([@player])
  end
end
