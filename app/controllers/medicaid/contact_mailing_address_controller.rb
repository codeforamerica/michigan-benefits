module Medicaid
  class ContactMailingAddressController < MedicaidStepsController
    private

    def skip?
      mail_sent_to_residential? ||
        no_reliable_mail_address?
    end

    def mail_sent_to_residential?
      current_application&.mail_sent_to_residential?
    end

    def no_reliable_mail_address?
      !current_application&.reliable_mail_address?
    end
  end
end
