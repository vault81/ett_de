Hanami::Model.migration do
  change do
    create_table :tournament_memberships do
      primary_key :id

      foreign_key :player_id, :players, null: false
      foreign_key :tournament_id, :tournaments, null: false, on_delete: :cascade

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
