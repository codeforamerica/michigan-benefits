# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.boolean :accepts_text_messages
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
