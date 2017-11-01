# frozen_string_literal: true

module Medicaid
  class ContactSocialSecurityController < Medicaid::ManyMemberStepsController
    private

    def skip?
      no_submit_ssn?
    end

    def no_submit_ssn?
      !current_application&.submit_ssn?
    end

    def member_attrs
      %i[last_four_ssn birthday]
    end
  end
end
