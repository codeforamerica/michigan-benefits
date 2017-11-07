module Medicaid
  class ContactHomeAddress < Step
    step_attributes(
      :residential_street_address,
      :residential_city,
      :residential_zip,
      :mailing_address_same_as_residential_address,
    )

    validates :residential_street_address,
      presence: { message: "Make sure to provide a street address" }

    validates :residential_city,
      presence: { message: "Make sure to provide a city" }

    validates :residential_zip,
      length: { is: 5, message: "Make sure your ZIP code is 5 digits long" }
  end
end
