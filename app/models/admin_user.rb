class AdminUser < ApplicationRecord
  devise(
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :otp_authenticatable,
  )
end
