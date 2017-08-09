class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.timestamps null: false
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :county, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.boolean :mailing, default: true, null: false
      t.belongs_to :snap_application, index: true
    end
  end
end
