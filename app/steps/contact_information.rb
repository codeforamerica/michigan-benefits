class ContactInformation < Step
  step_attributes(
    :email,
    :phone_number,
  )

  validates(
    :phone_number,
    ten_digit_phone_number: true,
  )
end
