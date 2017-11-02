class RemoveSsn < ActiveRecord::Migration[5.1]
  def up
    safety_assured do
      remove_column :medicaid_applications, :encrypted_ssn
      remove_column :medicaid_applications, :encrypted_ssn_iv
      remove_column :members, :encrypted_ssn
      remove_column :members, :encrypted_ssn_iv
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
