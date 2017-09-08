class AddEmailSubscribedToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :email_subscribed, :boolean
  end
end
