class AddAnyoneMarriedToMedicaidApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_married, :boolean
    change_column_default :medicaid_applications, :anyone_married, false
  end

  def down
    remove_column :medicaid_applications, :anyone_married
  end
end
