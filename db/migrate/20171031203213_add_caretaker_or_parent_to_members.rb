class AddCaretakerOrParentToMembers < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :caretaker_or_parent, :boolean
    change_column_default :members, :caretaker_or_parent, false
  end

  def down
    safety_assured do
      remove_column :members, :caretaker_or_parent
    end
  end
end
