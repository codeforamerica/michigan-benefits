class AddHourlyOrSalaryToEmployment < ActiveRecord::Migration[5.1]
  def change
    add_column :employments, :hourly_or_salary, :integer
    change_column_default :employments, :hourly_or_salary, from: nil, to: 0
  end
end
