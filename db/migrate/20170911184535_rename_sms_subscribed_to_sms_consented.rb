class RenameSmsSubscribedToSmsConsented < ActiveRecord::Migration[5.1]
  def change
    rename_column :snap_applications, :sms_subscribed, :sms_consented
    remove_column :snap_applications, :email_subscribed, type: :boolean
    remove_column :snap_applications, :interview_preference, type: :string
  end
end
