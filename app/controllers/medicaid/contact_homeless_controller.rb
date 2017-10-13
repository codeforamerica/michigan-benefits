# frozen_string_literal: true

module Medicaid
  class ContactHomelessController < MedicaidStepsController
    private

    def skip?
      mail_sent_to_residential? || reliable_mail_address?
    end

    def mail_sent_to_residential?
      current_application&.mail_sent_to_residential?
    end

    def reliable_mail_address?
      current_application&.reliable_mail_address?
    end
  end
end
