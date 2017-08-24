class RemoveTaxDeductibleExpenses < ActiveRecord::Migration[5.1]
  def change
    remove_column :snap_applications, :tax_deductible_expenses, :string, default: [], array: true
    remove_column :snap_applications, :monthly_tax_deductible_expenses, :integer
    remove_column :snap_applications, :tax_deductible, :boolean
  end
end
