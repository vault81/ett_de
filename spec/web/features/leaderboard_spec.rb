# spec/web/features/list_books_spec.rb
require 'features_helper'

RSpec.describe 'List top players' do
  let(:repository) { PlayerRepository.new }
  before do
    repository.clear

    repository.create(
      ett_name: 'luschenkiller',
      ett_id: 200_672,
      ett_elo: 1700,
      ett_wins: 20,
      ett_losses: 30,
      ett_rank: 1
    )
    repository.create(
      ett_name: 'lusche',
      ett_id: 200_1,
      ett_elo: 1700,
      ett_wins: 20,
      ett_losses: 30,
      ett_rank: 1
    )
  end

  it 'displays each book on the page' do
    visit '/leaderboard'

    within '#players' do
      expect(page).to have_selector('.player', count: 2),
      'Expected to find 2 players'
    end
  end
end
