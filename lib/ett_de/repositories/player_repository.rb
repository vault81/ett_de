class PlayerRepository < Hanami::Repository
  associations do
    has_one :match_info
    has_one :tournament, as: :league
    has_many :tournament_memberships
    has_many :tournaments, through: :tournament_memberships
  end

  def find_with_relations(id)
    aggregate(:tournaments, :match_info).where(id: id).one
  end

  def all_with_league(order: nil, reverse: nil)
    query = self.aggregate(:tournaments, :match_info)
    query = query.order(order) if order
    query = query.reverse if reverse

    players = query.map_to(Player).to_a
    with_leagues(players)
  end

  def find_by_ett_name(ett_name)
    players.where(ett_name: ett_name).one
  end

  def update_or_create_by_ett_id(params)
    entity = players.where(params.slice(:ett_id)).one

    unless entity.nil?
      entity = update(entity.id, params)
      return entity
    end

    create(params)
  end

  def find_or_create_by_ett_id(params)
    entity = players.where(params.slice(:ett_id)).one

    return entity unless entity.nil?

    create(params)
  end

  private

  def with_leagues(players)
    players.map { |player| with_league(player) }
  end

  def with_league(player)
    league = player.tournaments.sort_by(&:rank).first
    return player if league.nil?
    Player.new(league: league, **player.to_h)
  end

  def tournament_repo
    @tournament_repo ||= TournamentRepository.new
  end
end
