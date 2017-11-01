class AddSignatureToMedicaidApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :medicaid_applications, :signature, :string
    add_column :medicaid_applications, :signed_at, :datetime
  end
end
