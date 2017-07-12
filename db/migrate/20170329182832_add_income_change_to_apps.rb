# frozen_string_literal: true

class AddIncomeChangeToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :income_change, :boolean
  end
end
