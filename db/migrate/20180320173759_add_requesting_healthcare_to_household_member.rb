class AddRequestingHealthcareToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :requesting_healthcare, :integer
    change_column_default :household_members, :requesting_healthcare, from: nil, to: 0
  end
end
