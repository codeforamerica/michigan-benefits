class AddEmployedAsBooleanToMedicaid < ActiveRecord::Migration[5.1]
  def up
    add_column :members, :employed, :boolean
    change_column_default :members, :employed, false
  end

  def down
    safety_assured do
      remove_column :members, :employed
    end
  end
end
