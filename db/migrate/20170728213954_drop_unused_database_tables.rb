class DropUnusedDatabaseTables < ActiveRecord::Migration[5.1]
  def up
    drop_table :documents
    drop_table :household_members
    drop_table :apps
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
