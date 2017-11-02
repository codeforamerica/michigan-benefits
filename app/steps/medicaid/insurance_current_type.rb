# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentType < ManyMembersStep
    step_attributes(
      :insurance_type,
      :members,
    )

    def insured_members_requesting_insurance
      members_requesting_health_insurance.select(&:insured)
    end

    private

    def members_requesting_health_insurance
      members.select(&:requesting_health_insurance)
    end

    def validate_household_member(member)
      if member.requesting_health_insurance? && member.insured?
        unless member.insurance_type.present?
          member.errors.add(
            :insurance_type,
            "Please select a plan",
          )
        end
      end
    end
  end
end
