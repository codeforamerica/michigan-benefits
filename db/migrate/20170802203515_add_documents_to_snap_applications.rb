class AddDocumentsToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :documents, :string, array: true, default: []
  end
end
