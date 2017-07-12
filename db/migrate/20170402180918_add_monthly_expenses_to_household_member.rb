# frozen_string_literal: true

class AddMonthlyExpensesToHouseholdMember < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :monthly_expenses, :integer
  end
end
