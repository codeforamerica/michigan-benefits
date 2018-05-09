class ModifyOfficeLocation < ActiveRecord::Migration[5.1]
  def up
    add_column :snap_applications, :selected_office_location, :string
    add_column :snap_applications, :office_page, :string
    add_column :medicaid_applications, :selected_office_location, :string
    add_column :medicaid_applications, :office_page, :string
    safety_assured do
      execute "UPDATE snap_applications SET office_page = office_location;"
      execute "UPDATE medicaid_applications SET office_page = office_location;"

      commit_db_transaction

      remove_column :snap_applications, :office_location
      remove_column :medicaid_applications, :office_location
    end
  end

  def down
    add_column :snap_applications, :office_location, :string
    add_column :medicaid_applications, :office_location, :string
    safety_assured do
      execute "UPDATE snap_applications SET office_location = office_page;"
      execute "UPDATE medicaid_applications SET office_location = office_page;"

      commit_db_transaction

      remove_column :snap_applications, :selected_office_location
      remove_column :snap_applications, :office_page
      remove_column :medicaid_applications, :selected_office_location
      remove_column :medicaid_applications, :office_page
    end
  end
end
