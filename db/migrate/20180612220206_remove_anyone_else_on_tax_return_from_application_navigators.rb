class RemoveAnyoneElseOnTaxReturnFromApplicationNavigators < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      remove_column :application_navigators, :anyone_else_on_tax_return, :boolean
    end
  end
end
