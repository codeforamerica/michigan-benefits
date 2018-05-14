class AddHoursPerWeekToEmployment < ActiveRecord::Migration[5.1]
  def change
    add_column :employments, :hours_per_week, :integer
  end
end
