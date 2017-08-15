class AddHouseholdInfoFieldsToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :everyone_a_citizen, :boolean
    add_column :snap_applications, :anyone_disabled, :boolean
    add_column :snap_applications, :anyone_new_mom, :boolean
    add_column :snap_applications, :anyone_in_college, :boolean
    add_column :snap_applications, :anyone_living_elsewhere, :boolean
  end
end
