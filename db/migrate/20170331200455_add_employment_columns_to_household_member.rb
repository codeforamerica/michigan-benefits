class AddEmploymentColumnsToHouseholdMember < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :employer_name, :string
    add_column :household_members, :hours_per_week, :integer
    add_column :household_members, :pay_quantity, :integer
    add_column :household_members, :pay_interval, :string
    add_column :household_members, :income_consistent, :boolean
  end
end
