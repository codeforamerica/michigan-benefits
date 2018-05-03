class MailingAddressForm < Form
  set_address_attributes(
    :street_address,
    :street_address_2,
    :city,
    :zip,
  )

  validates :street_address,
            presence: { message: "Make sure to provide a street address", allow_blank: false }

  validates :city,
            presence: { message: "Make sure to provide a city", allow_blank: false }

  validates :zip,
            length: { is: 5, message: "Make sure the ZIP code is 5 digits long" }
end
