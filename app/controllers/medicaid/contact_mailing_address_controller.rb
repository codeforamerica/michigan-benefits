module Medicaid
  class ContactMailingAddressController < MedicaidStepsController
    private

    def skip?
      return false if mailing_address_different_from_residential_address?

      no_reliable_mail_address?
    end

    def no_reliable_mail_address?
      !current_application&.reliable_mail_address?
    end

    def mailing_address_different_from_residential_address?
      !current_application&.mailing_address_same_as_residential_address?
    end
  end
end
