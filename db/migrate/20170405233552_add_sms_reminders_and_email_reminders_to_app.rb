class AddSmsRemindersAndEmailRemindersToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :sms_reminders, :boolean
    add_column :apps, :email_reminders, :boolean
  end
end
