class AddMarriedToMember < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :married, :boolean
    change_column_default :members, :married, false
  end

  def down
    remove_column :members, :married
  end
end
