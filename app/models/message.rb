class Message < ApplicationRecord
  attr_accessor :custom_phone

  validates_presence_of :body
  validates(
    :phone,
    ten_digit_phone_number: true,
    phone: { allow_blank: true, message: I18n.t(:real_phone_number) },
  )
  validates(
    :custom_phone,
    ten_digit_phone_number: true,
    phone: { allow_blank: true, message: I18n.t(:real_phone_number) },
  )

  validate :at_least_one_phone

  def at_least_one_phone
    unless phone.present? || custom_phone.present?
      errors.add(:phone, "Please select a client or enter a phone number below.")
    end
  end
end
