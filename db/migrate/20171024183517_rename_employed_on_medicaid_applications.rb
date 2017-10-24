class RenameEmployedOnMedicaidApplications < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_employed, :boolean

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET anyone_employed=employed;
      SQL

      remove_column :medicaid_applications, :employed
      remove_column :medicaid_applications, :number_of_jobs
    end
  end

  def down
    add_column :medicaid_applications, :employed, :boolean
    add_column :medicaid_applications, :employed_number_of_jobs, :integer

    safety_assured do
      execute <<~SQL
        UPDATE medicaid_applications
        SET employed=anyone_employed;
      SQL

      remove_column :medicaid_applications, :anyone_employed
    end
  end
end
