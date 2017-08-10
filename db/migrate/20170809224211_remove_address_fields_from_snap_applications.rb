class RemoveAddressFieldsFromSnapApplications < ActiveRecord::Migration[5.1]
  def change
    remove_column :snap_applications, :street_address, :string
    remove_column :snap_applications, :zip, :string
    remove_column :snap_applications, :city, :string
    remove_column :snap_applications, :state, :string
    remove_column :snap_applications, :county, :string
  end
end
