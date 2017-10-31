class AddOtherIncomeToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :other_income, :boolean
    change_column_default :members, :other_income, false
  end

  def down
    safety_assured do
      remove_column :members, :other_income
    end
  end
end
