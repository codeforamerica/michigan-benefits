class AddHousingExpensesToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :rent_expense, :integer
    add_column :apps, :property_tax_expense, :integer
    add_column :apps, :insurance_expense, :integer
    add_column :apps, :utility_heat, :boolean
    add_column :apps, :utility_cooling, :boolean
    add_column :apps, :utility_electrity, :boolean
    add_column :apps, :utility_water_sewer, :boolean
    add_column :apps, :utility_trash, :boolean
    add_column :apps, :utility_phone, :boolean
    add_column :apps, :utility_other, :boolean
  end
end
