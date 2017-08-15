class AddEmploymentStatusToHouseholdMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :employment_status, :string
  end
end
