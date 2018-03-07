class AddRelationshipToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :relationship, :integer
    change_column_default :household_members, :relationship, from: nil, to: 0
  end
end
