class CreateSnapApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :snap_applications do |t|
      t.timestamps null: false
      t.string :name
      t.date :birthday
      t.string :street_address
      t.string :city
      t.string :county
      t.string :state
      t.string :zip
      t.string :signature
      t.datetime :signed_at
      t.belongs_to :user, index: true
    end
  end
end
