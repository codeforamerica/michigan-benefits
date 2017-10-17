class AddUploadDocumentsToMedicaidApplications < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :upload_documents, :boolean

    # More info on adding column with default value
    # github.com/ankane/strong_migrations#adding-a-column-with-a-default-value
    #
    add_column \
      :medicaid_applications,
      :documents,
      :string,
      array: true

    change_column_default :medicaid_applications, :documents, []

    commit_db_transaction
  end

  def down
    remove_column :medicaid_applications, :documents
    remove_column :medicaid_applications, :upload_documents
  end
end
