class SorceryCore < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email,            :null => false
      t.string :crypted_password, :null => false
      t.string :salt,             :null => false

      t.timestamps
    end

    add_index :accounts, :email, unique: true
  end
end