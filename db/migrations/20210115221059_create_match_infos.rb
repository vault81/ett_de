Hanami::Model.migration do
  change do
    alter_table :players do
      drop_column :ett_match_info
    end

    create_table :match_infos do
      primary_key :id
      foreign_key :player_id, :players, null: false, on_delete: :cascade

      column :test, :jsonb

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
