class AddLastFourSsnToMemberAndMedicaidApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :encrypted_last_four_ssn, :string
    add_column :members, :encrypted_last_four_ssn_iv, :string
    add_column :medicaid_applications, :encrypted_last_four_ssn, :string
    add_column :medicaid_applications, :encrypted_last_four_ssn_iv, :string
  end
end
