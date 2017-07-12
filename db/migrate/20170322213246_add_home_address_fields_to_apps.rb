# frozen_string_literal: true

class AddHomeAddressFieldsToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :home_address, :string
    add_column :apps, :home_city, :string
    add_column :apps, :home_zip, :string
    add_column :apps, :unstable_housing, :boolean, default: false
  end
end
