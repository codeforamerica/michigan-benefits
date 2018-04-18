class CreateIncomes < ActiveRecord::Migration[5.1]
  def change
    create_table :incomes do |t|
      t.string :income_type, null: false
      t.integer :amount
      t.references :household_member, index: true
      t.timestamps
    end
  end
end
