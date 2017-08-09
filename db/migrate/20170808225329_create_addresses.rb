class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.timestamps null: false
      t.string :street_address
      t.string :city
      t.string :county
      t.string :state
      t.string :zip
      t.boolean :mailing
      t.belongs_to :snap_application, index: true
    end
  end
end
