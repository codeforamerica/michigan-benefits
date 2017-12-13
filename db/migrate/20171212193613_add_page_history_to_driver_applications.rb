class AddPageHistoryToDriverApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_applications, :page_history, :string, array: true

    change_column_default :driver_applications, :page_history, from: nil, to: []
  end
end
