module Medicaid
  class ContactMailingAddress < Step
    step_attributes(
      :street_address,
      :street_address_2,
      :city,
      :county,
      :state,
      :zip,
    )

    validates :street_address,
      presence: { message: "Make sure to provide a street address" }

    validates :city,
      presence: { message: "Make sure to provide a city" }

    validates :zip,
      length: { is: 5, message: "Make sure your ZIP code is 5 digits long" }
  end
end
