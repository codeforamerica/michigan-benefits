class RenameDocumentsToPaperwork < ActiveRecord::Migration[5.1]
  def up
    add_column(:medicaid_applications, :upload_paperwork, :boolean)
    add_column(:medicaid_applications, :paperwork, :string, array: true)

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET upload_paperwork=upload_documents;

        UPDATE medicaid_applications
        SET paperwork=documents;
      SQL

      remove_column(:medicaid_applications, :upload_documents)
      remove_column(:medicaid_applications, :documents)
    end
  end

  def down
    add_column(:medicaid_applications, :documents, :string, array: true)
    add_column(:medicaid_applications, :upload_documents, :boolean)

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET upload_documents=upload_paperwork;

        UPDATE medicaid_applications
        SET documents=paperwork;
      SQL

      remove_column(:medicaid_applications, :paperwork)
      remove_column(:medicaid_applications, :upload_paperwork)
    end
  end
end
