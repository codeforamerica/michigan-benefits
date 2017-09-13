class AddIncomeAlimonyToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :income_alimony, :integer
  end
end
