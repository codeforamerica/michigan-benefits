# frozen_string_literal: true

class SorceryCore < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
