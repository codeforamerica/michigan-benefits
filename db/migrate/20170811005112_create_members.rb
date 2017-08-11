class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.timestamps null: false
      t.string :social_security_number
      t.string :marital_status, null: false
      t.string :sex, null: false
      t.belongs_to :snap_application, index: true
    end
  end
end
