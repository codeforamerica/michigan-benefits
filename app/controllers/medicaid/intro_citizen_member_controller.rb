# frozen_string_literal: true

module Medicaid
  class IntroCitizenMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      everyone_a_citizen? || single_member_household?
    end

    def member_attrs
      %i[citizen]
    end

    def everyone_a_citizen?
      current_application.everyone_a_citizen?
    end
  end
end
