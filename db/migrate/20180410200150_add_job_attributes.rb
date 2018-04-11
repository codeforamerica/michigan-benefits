class AddJobAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :application_navigators, :current_job, :boolean
    change_column_default :application_navigators, :current_job, from: nil, to: false

    add_column :household_members, :job_count, :integer
  end
end
