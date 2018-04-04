class AddPregnancyExpenseAttributesToMemberAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :anyone_pregnancy_expenses, :boolean
    change_column_default :application_navigators, :anyone_pregnancy_expenses, from: nil, to: true

    add_column :household_members, :pregnancy_expenses, :integer
    change_column_default :household_members, :pregnancy_expenses, from: nil, to: 0
  end
end
