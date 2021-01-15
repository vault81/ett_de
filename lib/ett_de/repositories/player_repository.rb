class PlayerRepository < Hanami::Repository
  def all_by_elo
    players.where().order(:ett_elo).reverse.to_a
  end
end
