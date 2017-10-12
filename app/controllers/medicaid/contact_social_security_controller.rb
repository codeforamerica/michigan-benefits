# frozen_string_literal: true

module Medicaid
  class ContactSocialSecurityController < StandardStepsController
    include MedicaidFlow

    private

    def skip?
      no_submit_ssn?
    end

    def no_submit_ssn?
      !current_application&.submit_ssn?
    end
  end
end
