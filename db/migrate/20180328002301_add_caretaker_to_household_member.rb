class AddCaretakerToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :caretaker, :integer
    change_column_default :household_members, :caretaker, from: nil, to: 0
  end
end
