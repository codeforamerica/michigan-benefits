class ResidentialAddressForm < Form
  set_navigator_attributes(:residential_mailing_same)

  set_address_attributes(
    :street_address,
    :street_address_2,
    :city,
    :zip,
  )

  validates :street_address,
    presence: { message: "Make sure to provide a street address" }

  validates :city,
    presence: { message: "Make sure to provide a city" }

  validates :zip,
    numericality: {
      only_integer: true,
      message: "Make sure the ZIP code is a number",
    },
    length: { is: 5, message: "Make sure the ZIP code is 5 digits long" }
end
