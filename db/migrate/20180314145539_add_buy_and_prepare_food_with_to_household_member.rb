class AddBuyAndPrepareFoodWithToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :buy_and_prepare_food_together, :integer
    change_column_default :household_members, :buy_and_prepare_food_together, from: nil, to: 0
  end
end
