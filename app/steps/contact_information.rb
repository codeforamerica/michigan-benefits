# frozen_string_literal: true

class ContactInformation < Step
  step_attributes(
    :email,
    :phone_number,
    :sms_subscribed,
  )

  validates :phone_number,
    presence: { message: "Make sure to provide a phone number at which we can reach you" }

  validates :sms_subscribed,
    inclusion: { in: %w(true false), message: "Make sure to answer this question" }
end
