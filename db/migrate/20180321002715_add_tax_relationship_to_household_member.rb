class AddTaxRelationshipToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :tax_relationship, :integer
    change_column_default :household_members, :tax_relationship, from: nil, to: 0
  end
end
