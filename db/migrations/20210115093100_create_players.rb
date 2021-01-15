Hanami::Model.migration do
  change do
    create_table :players do
      primary_key :id

      column :ett_id, Integer, null: false, unique: true
      column :ett_name, String
      column :ett_elo, Integer
      column :ett_wins, Integer
      column :ett_losses, Integer
      column :ett_rank, Integer
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
