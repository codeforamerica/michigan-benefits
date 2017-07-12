# frozen_string_literal: true

class AddChildSuportAndAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :child_support, :integer
    add_column :apps, :has_accounts, :boolean, default: false, null: false
    add_column :apps, :has_home, :boolean, default: false, null: false
    add_column :apps, :has_vehicle, :boolean, default: false, null: false
    add_column :apps, :total_money, :integer
  end
end
