class AddMonthlyPayToHouseholdMember < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :monthly_pay, :integer
  end
end
