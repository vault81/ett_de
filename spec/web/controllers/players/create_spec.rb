RSpec.describe Web::Controllers::Players::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[player: { ett_id: '42', ett_name: 'lusche' }] }
  let(:repository) { PlayerRepository.new }

  before { repository.clear }

  it 'creates a new book' do
    action.call(params)
    book = repository.last

    expect(book.id).to_not be_nil
  end

  it 'redirects the user to the books listing' do
    response = action.call(params)

    expect(response[0]).to eq(302)
    expect(response[1]['Location']).to eq('/leaderboard')
  end
end
