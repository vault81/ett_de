RSpec.describe Web::Views::Leaderboard::Index, type: :view do
  let(:exposures) { Hash[format: :html] }
  let(:template) do
    Hanami::View::Template.new('apps/web/templates/leaderboard/index.html.erb')
  end
  let(:view) { described_class.new(template, exposures) }
  let(:rendered) { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  context 'when there are players' do
    let(:player_1) do
      Player.new(
        ett_name: 'luschenkiller',
        ett_id: 200_672,
        ett_elo: 1700,
        ett_wins: 20,
        ett_losses: 30,
        ett_rank: 1
      )
    end
    let(:exposures) { Hash[players: [player_1]] }

    it 'lists them all' do
      expect(rendered.scan(/class="player"/).length).to eq(1)
      expect(rendered).to include('1700')
      expect(rendered).to include('20 Wins')
    end
  end
end
