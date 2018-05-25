class AddPaperworkToApplicationAndNavigator < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :upload_paperwork, :boolean
    change_column_default :application_navigators, :upload_paperwork, from: nil, to: true

    add_column :common_applications, :paperwork, :string, array: true
    change_column_default :common_applications, :paperwork, from: nil, to: []
  end
end
