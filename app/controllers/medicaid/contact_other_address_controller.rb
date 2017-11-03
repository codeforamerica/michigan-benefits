module Medicaid
  class ContactOtherAddressController < MedicaidStepsController
    private

    def skip?
      mail_sent_to_residential?
    end

    def mail_sent_to_residential?
      current_application&.mail_sent_to_residential?
    end
  end
end
