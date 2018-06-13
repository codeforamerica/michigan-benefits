class AddSelectedOfficeLocationToCommonApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :selected_office_location, :string
  end
end
