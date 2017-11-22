class ContactConfirmPhoneNumber < Step
  step_attributes(
    :phone_number,
  )

  validates(
    :phone_number,
    ten_digit_phone_number: true,
  )
end
