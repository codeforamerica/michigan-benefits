class AddExpenseColumnsToSnapApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :rent_expense, :integer
    add_column :snap_applications, :property_tax_expense, :integer
    add_column :snap_applications, :insurance_expense, :integer
    add_column :snap_applications, :utility_heat, :boolean
    add_column :snap_applications, :utility_cooling, :boolean
    add_column :snap_applications, :utility_electrity, :boolean
    add_column :snap_applications, :utility_water_sewer, :boolean
    add_column :snap_applications, :utility_trash, :boolean
    add_column :snap_applications, :utility_phone, :boolean
    add_column :snap_applications, :utility_other, :boolean

    add_column :snap_applications, :dependent_care, :boolean
    add_column :snap_applications, :medical, :boolean
    add_column :snap_applications, :court_ordered, :boolean
    add_column :snap_applications, :tax_deductible, :boolean

    add_column :snap_applications, :monthly_care_expenses, :integer
    add_column :snap_applications, :monthly_medical_expenses, :integer
    add_column :snap_applications, :monthly_court_ordered_expenses, :integer
    add_column :snap_applications, :monthly_tax_deductible_expenses, :integer

    add_column :snap_applications, :care_expenses, :string, default: [], array: true
    add_column :snap_applications, :medical_expenses, :string, default: [], array: true
    add_column :snap_applications, :court_ordered_expenses, :string, default: [], array: true
    add_column :snap_applications, :tax_deductible_expenses, :string, default: [], array: true
  end
end
