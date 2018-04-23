class AddVehiclesToNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :own_vehicles, :boolean
    change_column_default :application_navigators, :own_vehicles, from: nil, to: false
  end
end
