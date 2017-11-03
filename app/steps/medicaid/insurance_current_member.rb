# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentMember < Step
    step_attributes(
      :insured,
      :members,
    )

    def members_needing_insurance
      members.select(&:requesting_health_insurance)
    end

    def members_not_needing_insurance
      members.reject(&:requesting_health_insurance)
    end

    def valid?
      if members_needing_insurance.select(&:insured).any?
        true
      else
        errors.add(
          :insured,
          "Please select a member",
        )
        false
      end
    end
  end
end