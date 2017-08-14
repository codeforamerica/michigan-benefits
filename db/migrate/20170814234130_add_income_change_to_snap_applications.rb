class AddIncomeChangeToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :income_change, :boolean
    add_column :snap_applications, :income_change_explanation, :text
  end
end
