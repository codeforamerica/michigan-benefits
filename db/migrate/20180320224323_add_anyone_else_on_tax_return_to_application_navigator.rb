class AddAnyoneElseOnTaxReturnToApplicationNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_else_on_tax_return, :boolean
    change_column_default :application_navigators, :anyone_else_on_tax_return, from: nil, to: true
  end
end
