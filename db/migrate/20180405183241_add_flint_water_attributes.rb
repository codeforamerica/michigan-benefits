class AddFlintWaterAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_flint_water, :boolean
    change_column_default :application_navigators, :anyone_flint_water, from: nil, to: false

    add_column :household_members, :flint_water, :integer
    change_column_default :household_members, :flint_water, from: nil, to: 0
  end
end
