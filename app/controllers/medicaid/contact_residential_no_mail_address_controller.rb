module Medicaid
  class ContactResidentialNoMailAddressController < MedicaidStepsController
    private

    def skip?
      mail_sent_to_residential? ||
        reliable_mail_address? ||
        homeless?
    end

    def mail_sent_to_residential?
      current_application&.mail_sent_to_residential?
    end

    def reliable_mail_address?
      current_application&.reliable_mail_address?
    end

    def homeless?
      current_application&.homeless?
    end
  end
end
