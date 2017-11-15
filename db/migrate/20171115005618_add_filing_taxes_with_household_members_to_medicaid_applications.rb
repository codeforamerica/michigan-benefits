class AddFilingTaxesWithHouseholdMembersToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :filing_taxes_with_household_members, :boolean
  end
end
