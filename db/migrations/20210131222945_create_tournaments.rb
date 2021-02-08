Hanami::Model.migration do
  change do
    create_table :tournaments do
      primary_key :id

      column :challonge_id, Integer, null: false, unique: true
      column :challonge_state, String, null: false
      column :challonge_url, String, null: false
      column :short_name, String
      column :name, String
      column :color_hex, String
      column :rank, Integer

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
