class RemoveNotNullConstraintOnAddress < ActiveRecord::Migration[5.1]
  def change
    change_column_null :addresses, :county, true
  end
end
