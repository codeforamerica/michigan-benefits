# frozen_string_literal: true

class ContactInformation < Step
  attr_accessor :phone_number, :phone_number_as_normalized
  phony_normalize :phone_number, default_country_code: "US"

  step_attributes(
    :email,
    :phone_number,
    :sms_subscribed,
  )

  validates_plausible_phone :phone_number, with: /\A\+\d+/
  validates(
    :phone_number,
    presence: {
      message: "Make sure to provide a phone number at which we can reach you",
    },
  )

  validates(
    :sms_subscribed,
    inclusion: {
      in: %w(true false),
      message: "Make sure to answer this question",
    },
  )
end
