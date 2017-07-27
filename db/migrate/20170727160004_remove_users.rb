class RemoveUsers < ActiveRecord::Migration[5.1]
  def up
    remove_column :snap_applications, :user_id
    remove_column :apps, :user_id
    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps
    end

    add_index :users, :email, unique: true

    add_reference :snap_applications, :user, index: true
    add_reference :apps, :user, index: true
  end
end
