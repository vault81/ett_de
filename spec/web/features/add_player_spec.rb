# spec/web/features/add_book_spec.rb
require 'features_helper'

RSpec.describe 'Add a book' do
  after { PlayerRepository.new.clear }

  it 'can create a new book' do
    visit '/players/new'

    within 'form#player-form' do
      fill_in 'Ett id or name', with: '200672'

      click_button 'Create'
    end

    expect(page).to have_current_path('/leaderboard')
    expect(page).to have_content('luschenkiller')
  end
end
