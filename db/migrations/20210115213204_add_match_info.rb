Hanami::Model.migration do
  change do
    alter_table :players do
      add_column :ett_match_info, 'jsonb'

    end
  end
end
