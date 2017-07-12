# frozen_string_literal: true

class AddHasHome < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :has_home, :boolean
    add_column :apps, :has_vehicle, :boolean
  end
end
