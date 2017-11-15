class AddFilingTaxesWithPrimaryMemberToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :filing_taxes_with_primary_member, :boolean
  end
end
