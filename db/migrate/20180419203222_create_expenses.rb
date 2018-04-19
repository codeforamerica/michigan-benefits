class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.string :expense_type, null: false
      t.integer :amount
      t.references :common_application, index: true
      t.timestamps
    end
  end
end
