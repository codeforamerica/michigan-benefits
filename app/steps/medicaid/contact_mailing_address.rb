module Medicaid
  class ContactMailingAddress < Step
    step_attributes(
      :mailing_street_address,
      :mailing_city,
      :mailing_zip,
    )

    validates :mailing_street_address,
      presence: { message: "Make sure to provide a street address" }

    validates :mailing_city,
      presence: { message: "Make sure to provide a city" }

    validates :mailing_zip,
      length: { is: 5, message: "Make sure your ZIP code is 5 digits long" }
  end
end
