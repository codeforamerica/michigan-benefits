class AddUnstableHousingToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :unstable_housing, :boolean, default: false
  end
end
