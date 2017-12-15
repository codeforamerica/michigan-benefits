class RemoveMichiganResidentNullConstraint < ActiveRecord::Migration[5.1]
  def change
    change_column_null :medicaid_applications, :michigan_resident, true
  end
end
