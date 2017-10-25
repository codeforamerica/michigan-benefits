class AddSelfEmployedToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :self_employed, :boolean
    change_column_default :members, :self_employed, false
    commit_db_transaction
  end

  def down
    remove_column :members, :self_employed
  end
end
