class AddEmploymentsCountToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :employments_count, :integer
    change_column_default :household_members, :employments_count, from: nil, to: 0
  end
end
