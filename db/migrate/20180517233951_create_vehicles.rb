class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_type, null: false
      t.string :year_make_model
      t.timestamps
    end
  end
end
