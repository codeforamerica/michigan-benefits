class DeviseOtpAddToAdminUsers < ActiveRecord::Migration[5.1]
  def up
    safety_assured do
      add_column :admin_users, :otp_auth_secret, :string
      add_column :admin_users, :otp_recovery_secret, :string
      add_column :admin_users, :otp_enabled, :boolean, default: false, null: false
      add_column :admin_users, :otp_mandatory, :boolean, default: false, null: false
      add_column :admin_users, :otp_enabled_on, :datetime
      add_column :admin_users, :otp_failed_attempts, :integer, default: 0, null: false
      add_column :admin_users, :otp_recovery_counter, :integer, default: 0, null: false
      add_column :admin_users, :otp_persistence_seed, :string
      add_column :admin_users, :otp_session_challenge, :string
      add_column :admin_users, :otp_challenge_expires, :datetime

      add_index :admin_users, :otp_session_challenge, unique: true
      add_index :admin_users, :otp_challenge_expires
    end
  end

  def down
    remove_column :admin_users, :otp_auth_secret
    remove_column :admin_users, :otp_recovery_secret
    remove_column :admin_users, :otp_enabled
    remove_column :admin_users, :otp_mandatory
    remove_column :admin_users, :otp_enabled_on
    remove_column :admin_users, :otp_session_challenge
    remove_column :admin_users, :otp_challenge_expires
    remove_column :admin_users, :otp_failed_attempts
    remove_column :admin_users, :otp_recovery_counter
    remove_column :admin_users, :otp_persistence_seed
  end
end
