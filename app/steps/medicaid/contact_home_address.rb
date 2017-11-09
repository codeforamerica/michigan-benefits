module Medicaid
  class ContactHomeAddress < Step
    step_attributes(
      :street_address,
      :city,
      :zip,
      :mailing_address_same_as_residential_address,
    )

    validates :street_address,
      presence: { message: "Make sure to provide a street address" }

    validates :city,
      presence: { message: "Make sure to provide a city" }

    validates :zip,
      length: { is: 5, message: "Make sure your ZIP code is 5 digits long" }
  end
end
