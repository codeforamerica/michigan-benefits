# frozen_string_literal: true

module Medicaid
  class ContactTextMessages < Step
    step_attributes(
      :sms_consented,
      :sms_phone_number,
    )
  end
end
