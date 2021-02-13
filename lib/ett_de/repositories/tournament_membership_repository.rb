class TournamentMembershipRepository < Hanami::Repository
  associations do
    belongs_to :player
    belongs_to :tournament
  end

  # @param player_id [Integer]
  # @param tournament_id [Integer]
  # @return [TournamentMembership]
  def find_or_create(player_id, tournament_id)
    entity =
      tournament_memberships.where(
        player_id: player_id,
        tournament_id: tournament_id
      ).one

    return entity unless entity.nil?

    create(player_id: player_id, tournament_id: tournament_id)
  end
end
