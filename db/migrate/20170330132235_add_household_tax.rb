# frozen_string_literal: true

class AddHouseholdTax < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :household_tax, :boolean
  end
end
