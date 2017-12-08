class ExtractEmploymentsModel < ActiveRecord::Migration[5.1]
  def change
    create_table :employments do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "pay_quantity"
      t.string "employer_name"
      t.string "payment_frequency"
      t.integer "member_id", null: false
    end
  end
end
