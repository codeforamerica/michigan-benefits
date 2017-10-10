class AddTrackingNumberToDriverApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_applications, :tracking_number, :string
  end
end
