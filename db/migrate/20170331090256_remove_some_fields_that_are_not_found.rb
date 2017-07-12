# frozen_string_literal: true

class RemoveSomeFieldsThatAreNotFound < ActiveRecord::Migration[5.0]
  def change
    remove_column :apps, :has_home
    remove_column :apps, :has_vehicle
  end
end
