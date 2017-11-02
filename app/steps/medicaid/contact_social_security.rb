# frozen_string_literal: true

module Medicaid
  class ContactSocialSecurity < ManyMembersStep
    step_attributes(:members)

    def validate_household_member(member)
      member.valid?
      member.errors[:last_four_ssn].blank?
    end

    def members_requesting_health_insurance
      members.select(&:requesting_health_insurance)
    end
  end
end
