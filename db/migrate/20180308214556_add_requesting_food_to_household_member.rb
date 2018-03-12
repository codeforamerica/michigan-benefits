class AddRequestingFoodToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :requesting_food, :integer
    change_column_default :household_members, :requesting_food, from: nil, to: 0
  end
end
