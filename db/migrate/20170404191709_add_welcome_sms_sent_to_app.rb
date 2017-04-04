class AddWelcomeSmsSentToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :welcome_sms_sent, :boolean, default: false
  end
end
