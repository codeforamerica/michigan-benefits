class Member < ApplicationRecord
  attr_encrypted :ssn, key: Rails.application.secrets.secret_key_for_ssn_encryption

  def full_name
    "#{first_name} #{last_name}"
  end
end
