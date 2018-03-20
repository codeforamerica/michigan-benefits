class AddFilingTaxesNextYearToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :filing_taxes_next_year, :integer
    change_column_default :household_members, :filing_taxes_next_year, from: nil, to: 0
  end
end
