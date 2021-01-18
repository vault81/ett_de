Hanami::Model.migration do
  change do
    alter_table :players do
      add_column :ett_last_online, DateTime
    end
  end
end
