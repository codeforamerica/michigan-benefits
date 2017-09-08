# frozen_string_literal: true

class ContactPreference < Step
  step_attributes(
    :email_subscribed,
    :sms_subscribed,
  )
end
