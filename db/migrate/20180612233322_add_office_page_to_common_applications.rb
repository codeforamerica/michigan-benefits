class AddOfficePageToCommonApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :common_applications, :office_page, :string
  end
end
