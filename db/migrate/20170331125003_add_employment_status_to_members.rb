class AddEmploymentStatusToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :household_members, :employment_status, :string
  end
end
