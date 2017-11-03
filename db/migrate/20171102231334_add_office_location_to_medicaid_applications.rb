class AddOfficeLocationToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :office_location, :string
  end
end
