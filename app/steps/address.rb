# frozen_string_literal: true

class Address < Step
  step_attributes(
    :street_address,
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

  validates :county,
    inclusion: { in: %w(Genesee), message: "Make sure the county is Genesee" }

  validates :state,
    inclusion: { in: %w(MI), message: "Make sure the county is MI" }
end
