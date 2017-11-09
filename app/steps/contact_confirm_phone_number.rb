class ContactConfirmPhoneNumber < Step
  step_attributes(
    :phone_number,
  )

  validates(
    :phone_number,
    ten_digit_phone_number: true,
    presence: {
      message: "Make sure to provide a phone number where we can reach you",
    },
  )
end
