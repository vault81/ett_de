class PlayerRepository < Hanami::Repository
  associations do
    has_many :tournament_memberships
    has_many :tournaments, through: :tournament_memberships
  end

  def all_by_elo
    aggregate(:tournaments).where.order(:ett_elo).reverse.to_a
  end

  def find_by_ett_name(ett_name)
    players.where(ett_name: ett_name).one
  end
end
