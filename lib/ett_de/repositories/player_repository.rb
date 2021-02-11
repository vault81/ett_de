class PlayerRepository < Hanami::Repository
  associations do
    has_one :match_info
    has_many :tournament_memberships
    has_many :tournaments, through: :tournament_memberships
  end
  def find_with_relations(id)
    aggregate(:tournaments, :match_info).where(id: id).one
  end

  def all_with_tournaments
    aggregate(:tournaments).where.to_a
  end

  def all_in_order(order)
    aggregate(:tournaments).where.order(order).reverse.to_a
  end

  def all_by_elo
    aggregate(:tournaments).where.order(:ett_elo).reverse.to_a
  end

  def find_by_ett_name(ett_name)
    players.where(ett_name: ett_name).one
  end

  def find_or_create(params)
    entity = players.where(params.slice(:ett_id)).one

    return entity unless entity.nil?

    create(params)
  end
end
