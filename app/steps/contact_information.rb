# frozen_string_literal: true

class ContactInformation < Step
  step_attributes(
    :email,
    :phone_number,
  )

  validates(
    :phone_number,
    ten_digit_phone_number: true,
    presence: {
      message: "Make sure to provide a phone number at which we can reach you",
    },
  )
end
