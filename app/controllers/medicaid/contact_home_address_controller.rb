module Medicaid
  class ContactHomeAddressController < MedicaidStepsController
    private

    def skip?
      no_mail_sent_to_residential_address?
    end

    def no_mail_sent_to_residential_address?
      !current_application&.mail_sent_to_residential?
    end
  end
end
