class AddOfficeLocationToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :office_location, :string
  end
end
