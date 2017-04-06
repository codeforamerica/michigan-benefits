class AddExpensesAdditionalSourcesColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :dependent_care, :boolean
    add_column :apps, :medical, :boolean
    add_column :apps, :court_ordered, :boolean
    add_column :apps, :tax_deductible, :boolean
  end
end
