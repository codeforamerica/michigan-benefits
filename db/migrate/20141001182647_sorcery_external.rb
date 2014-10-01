class SorceryExternal < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :account_id, :null => false
      t.string :provider, :uid, :null => false

      t.timestamps
    end
  end
end