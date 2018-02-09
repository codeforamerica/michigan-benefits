module Medicaid
  class ContactTextMessages < Step
    step_attributes(
      :sms_consented,
      :sms_phone_number,
    )

    validates(
      :sms_phone_number,
      ten_digit_phone_number: true,
      phone: { allow_blank: true, message: I18n.t(:real_phone_number) },
    )
  end
end
