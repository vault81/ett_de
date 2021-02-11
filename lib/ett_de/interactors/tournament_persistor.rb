require 'hanami/interactor'
require 'challonge'

class TournamentPersistor
  include Hanami::Interactor

  def initialize; end

  def call(attributes)
    tournament_resp = Challonge.new.get(attributes[:challonge_url])[:tournament]
    tournament = persist_tournament(tournament_resp, attributes)

    attributes[:member_ett_ids]&.map do |member_ett_id|
      puts "Creating player"
      player = find_or_create_player(member_ett_id)
      persist_tournament_member(player, tournament)
    end
  end

  private

  def persist_tournament_member(player, tournament)
    TournamentMembershipRepository.new.find_or_create(player.id, tournament.id)
  end

  # rubocop:disable Metrics/MethodLength
  def persist_tournament(tournament_resp, attributes)
    TournamentRepository.new.update_or_create(
      tournament_resp[:id],
      {
        challonge_state: tournament_resp[:state],
        challonge_url: attributes[:challonge_url],
        short_name: attributes[:short_name],
        name: attributes[:name],
        color_hex: attributes[:color_hex],
        rank: attributes[:rank].to_i
      }
    )
  end

  # rubocop:enable Metrics/MethodLength

  def find_or_create_player(ett_id)
    params = EttAPI.fetch_player(ett_id)
    PlayerRepository.new.find_or_create(params)
  end
end
