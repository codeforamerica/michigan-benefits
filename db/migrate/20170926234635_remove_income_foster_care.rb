class RemoveIncomeFosterCare < ActiveRecord::Migration[5.1]
  def change
    remove_column :snap_applications, :income_foster_care, :integer
  end
end
