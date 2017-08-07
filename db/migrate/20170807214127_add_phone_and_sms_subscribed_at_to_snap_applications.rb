class AddPhoneAndSmsSubscribedAtToSnapApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :snap_applications, :phone_number, :string
    add_column :snap_applications, :sms_subscribed, :boolean
  end
end
