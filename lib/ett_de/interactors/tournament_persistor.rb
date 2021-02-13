require 'hanami/interactor'
require 'challonge'

class TournamentPersistor
  include Hanami::Interactor

  def initialize; end

  # persists a tournament
  # @param attributes [Hash]
  # @return [Boolean]
  def call(attributes)
    tournament_resp = Challonge.new.get(attributes[:challonge_url])[:tournament]
    tournament = persist_tournament(tournament_resp, attributes)

    attributes[:member_ett_ids]&.map do |member_ett_id|
      puts 'Creating player'
      params = EttAPI.fetch_player(member_ett_id)
      player = PlayerRepository.new.update_or_create_by_ett_id(params)

      persist_tournament_member(player, tournament)
    end
    true
  end

  private

  # @param player [Player]
  # @param tournament [Tournament]
  # @return [TournamentMembership]
  def persist_tournament_member(player, tournament)
    TournamentMembershipRepository.new.find_or_create(
      player.id,
      tournament.id.to_s
    )
    TournamentMembershipRepository.new.find_or_create(player.id, tournament.id)
  end

  # rubocop:disable Metrics/MethodLength
  # @param tournament_resp [Hash]
  # @param attributes [Hash]
  # @return [Tournament]
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
end
