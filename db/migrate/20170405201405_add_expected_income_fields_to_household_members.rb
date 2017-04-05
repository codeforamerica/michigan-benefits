class AddExpectedIncomeFieldsToHouseholdMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :expected_income_this_year, :integer
    add_column :household_members, :expected_income_next_year, :integer
  end
end
