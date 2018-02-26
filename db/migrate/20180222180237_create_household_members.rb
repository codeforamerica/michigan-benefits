class CreateHouseholdMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :household_members do |t|
      t.string :first_name
      t.string :last_name
      t.integer :sex
      t.datetime :birthday
      t.references :common_application, index: true
      t.timestamps
    end
  end
end
