# frozen_string_literal: true

module Medicaid
  class IntroCitizenMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      everyone_a_citizen? ||
        (single_member_not_a_citizen? && update_single_member)
    end

    def step_class
      Medicaid::Citizen
    end

    def member_attrs
      %i[citizen]
    end

    def everyone_a_citizen?
      current_application.everyone_a_citizen?
    end

    def single_member_not_a_citizen?
      single_member? && not_a_citizen?
    end

    def single_member?
      current_application.members.count == 1
    end

    def not_a_citizen?
      !current_application.everyone_a_citizen?
    end

    def update_single_member
      current_application.primary_member.update(citizen: false)
    end
  end
end
