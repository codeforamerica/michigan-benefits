class AddHasProofOfIncome < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :has_proof_of_income, :integer
    change_column_default :members, :has_proof_of_income, from: nil, to: 0
  end
end
