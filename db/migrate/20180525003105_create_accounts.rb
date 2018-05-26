class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :account_type, null: false
      t.string :institution
      t.timestamps
    end
  end
end
