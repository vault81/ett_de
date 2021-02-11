Hanami::Model.migration do
  change do
    create_table :challonge_matches do
      primary_key :id
      foreign_key :tournament_id, :tournaments, null: false, on_delete: :cascade
      foreign_key :winner_player_id, :player, on_delete: :cascade
      foreign_key :loser_player_id, :player, on_delete: :cascade
      foreign_key :player_one_player_id, :player, on_delete: :cascade
      foreign_key :player_two_player_id, :player, on_delete: :cascade

      column :challonge_id, Integer
      column :challonge_state, String
      column :challonge_identifier, String
      column :challonge_round, Integer
      column :challonge_play_order, Integer
      column :challonge_scores_csv, Integer
      column :completed_at, DateTime

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
