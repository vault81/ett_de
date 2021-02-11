class TournamentRepository < Hanami::Repository
  associations do
    has_many :tournament_memberships
    has_many :players, through: :tournament_memberships, as: :members
  end

  def find_with_relations(id)
    aggregate(:members).where(id: id).one
  end

  def update_or_create(challonge_id, attrs)
    entity = tournaments.where(challonge_id: challonge_id).one
    unless entity.nil?
      ent = update(entity.id, attrs)
      return ent
    end
    create(attrs.merge(challonge_id: challonge_id))
  end
end
