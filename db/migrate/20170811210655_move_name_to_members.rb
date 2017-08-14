class MoveNameToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :first_name, :string
    add_column :members, :last_name, :string

    remove_column :snap_applications, :name, :string

    change_column_null :members, :marital_status, true
    change_column_null :members, :sex, true
  end
end
