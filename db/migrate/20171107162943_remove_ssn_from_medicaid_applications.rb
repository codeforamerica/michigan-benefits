class RemoveSsnFromMedicaidApplications < ActiveRecord::Migration[5.1]
  def up
    safety_assured do
      remove_column :medicaid_applications, :encrypted_ssn
      remove_column :medicaid_applications, :encrypted_ssn_iv
    end
  end

  def down
    add_column :medicaid_applications, :encrypted_ssn, :string
    add_column :medicaid_applications, :encrypted_ssn_iv, :string
  end
end
