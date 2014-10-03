class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.timestamps
    end

    create_table :account_roles do |t|
      t.belongs_to :account, null: false
      t.belongs_to :role, null: false
      t.timestamps

      t.index [:account_id, :role_id], unique: true
    end
  end
end
