Hanami::Model.migration do
  change do
    alter_table :players do
      add_column :ett_status, String
    end
  end
end
