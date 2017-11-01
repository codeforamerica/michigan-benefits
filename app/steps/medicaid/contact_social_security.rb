# frozen_string_literal: true

module Medicaid
  class ContactSocialSecurity < ManyMembersStep
    step_attributes(:members)

    def validate_household_member(member)
      member.valid?
      member.errors[:last_four_ssn].blank?
    end
  end
end
