class MoveOtherIncomeTypesToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :other_income_types, :string, array: true

    change_column_default :members, :other_income_types, from: nil, to: []
  end
end
