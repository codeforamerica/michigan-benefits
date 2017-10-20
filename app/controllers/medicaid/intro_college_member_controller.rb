# frozen_string_literal: true

module Medicaid
  class IntroCollegeMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      single_member_household? || !current_application.anyone_in_college?
    end

    def member_attrs
      %i[in_college]
    end
  end
end
