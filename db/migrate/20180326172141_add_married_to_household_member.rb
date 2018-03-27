class AddMarriedToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :married, :integer
    change_column_default :household_members, :married, from: nil, to: 0
  end
end
