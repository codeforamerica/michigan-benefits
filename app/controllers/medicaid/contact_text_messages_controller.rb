module Medicaid
  class ContactTextMessagesController < MedicaidStepsController
    private

    def step_class
      Medicaid::ContactTextMessages
    end

    def existing_attributes
      HashWithIndifferentAccess.new(text_message_attributes)
    end

    def text_message_attributes
      {
        sms_consented: current_application.sms_consented,
        sms_phone_number: sms_phone_or_regular_phone,
      }
    end

    def sms_phone_or_regular_phone
      current_application.sms_phone_number || current_application.phone_number
    end
  end
end
