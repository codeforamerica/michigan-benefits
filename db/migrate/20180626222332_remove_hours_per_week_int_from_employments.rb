class RemoveHoursPerWeekIntFromEmployments < ActiveRecord::Migration[5.1]
  def change
    remove_column :employments, :hours_per_week_int, :integer
  end
end
