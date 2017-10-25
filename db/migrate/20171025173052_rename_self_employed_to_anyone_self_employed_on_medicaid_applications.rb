class RenameSelfEmployedToAnyoneSelfEmployedOnMedicaidApplications < ActiveRecord::Migration[5.1]
  def up
    add_column :medicaid_applications, :anyone_self_employed, :boolean
    change_column_default :medicaid_applications, :anyone_self_employed, false
    commit_db_transaction

    safety_assured do
      execute "UPDATE medicaid_applications SET anyone_self_employed=self_employed"
      remove_column :medicaid_applications, :self_employed, :boolean
    end
  end

  def down
    add_column :medicaid_applications, :self_employed, :boolean

    safety_assured do
      execute "UPDATE medicaid_applications SET self_employed=anyone_self_employed"
      remove_column :medicaid_applications, :anyone_self_employed
    end
  end
end
