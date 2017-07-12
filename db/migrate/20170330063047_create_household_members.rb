# frozen_string_literal: true

class CreateHouseholdMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :household_members do |t|
      t.references :app, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :sex
      t.string :relationship
      t.string :ssn
      t.boolean :in_home
      t.boolean :buy_food_with

      t.timestamps
    end
  end
end
