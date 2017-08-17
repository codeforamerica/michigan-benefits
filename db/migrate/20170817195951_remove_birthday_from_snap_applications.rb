class RemoveBirthdayFromSnapApplications < ActiveRecord::Migration[5.1]
  def change
    remove_column :snap_applications, :birthday, :datetime
  end
end
