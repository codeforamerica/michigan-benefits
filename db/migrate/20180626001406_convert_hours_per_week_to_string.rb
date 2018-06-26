class ConvertHoursPerWeekToString < ActiveRecord::Migration[5.1]
  def change
    rename_column :employments, :hours_per_week, :hours_per_week_int
    add_column :employments, :hours_per_week, :string
  end
end
