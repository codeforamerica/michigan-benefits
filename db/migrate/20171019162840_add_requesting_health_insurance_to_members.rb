class AddRequestingHealthInsuranceToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :requesting_health_insurance, :boolean
    change_column_default :members, :requesting_health_insurance, true
    commit_db_transaction
  end

  def down
    remove_column :members, :requesting_health_insurance
  end
end
