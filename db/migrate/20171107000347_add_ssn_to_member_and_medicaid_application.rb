class AddSsnToMemberAndMedicaidApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :encrypted_ssn, :string
    add_column :members, :encrypted_ssn_iv, :string
    add_column :medicaid_applications, :encrypted_ssn, :string
    add_column :medicaid_applications, :encrypted_ssn_iv, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
