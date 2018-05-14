class AddSelfEmploymentToHouseholdMember < ActiveRecord::Migration[5.1]
  def change
    add_column :household_members, :self_employment_description, :string
    add_column :household_members, :self_employment_income, :integer
    add_column :household_members, :self_employment_expense, :integer
  end
end
