class AddBabyCountToHouseholdMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :baby_count, :integer
  end
end
