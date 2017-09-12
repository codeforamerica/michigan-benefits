class RemoveFaxedAtFromSnapApplications < ActiveRecord::Migration[5.1]
  def change
    remove_column :snap_applications, :faxed_at, :datetime
  end
end
