class AddInsuredToMedicaidApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :insured, :boolean
    add_column :medicaid_applications, :employed, :boolean
    add_column :medicaid_applications, :income_not_from_job, :boolean
    add_column :medicaid_applications, :submit_ssn, :boolean
  end
end
