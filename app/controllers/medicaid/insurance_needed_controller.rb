# frozen_string_literal: true

module Medicaid
  class InsuranceNeededController < Medicaid::ManyMemberStepsController
    private

    def skip?
      single_member_household?
    end

    def single_member_household?
      current_application.members.empty? ||
        current_application.members.count == 1
    end

    def member_attrs
      %i[requesting_health_insurance]
    end
  end
end
