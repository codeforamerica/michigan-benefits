# frozen_string_literal: true

class MailingAddress < Step
  step_attributes(
    :city,
    :county,
    :mailing_address_same_as_residential_address,
    :state,
    :street_address,
    :zip,
  )

  validates :street_address,
    presence: { message: "Make sure to provide a street address" }

  validates :city,
    presence: { message: "Make sure to provide a city" }

  validates :zip,
    length: { is: 5, message: "Make sure your ZIP code is 5 digits long" }

  validates :county,
    inclusion: { in: %w(Genesee), message: "Make sure the county is Genesee" }

  validates :state,
    inclusion: { in: %w(MI), message: "Make sure the county is MI" }

  validates(
    :mailing_address_same_as_residential_address,
    inclusion: {
      in: %w(true false),
      message: "Make sure to answer this question",
    },
  )
end
