module Medicaid
  class ContactSocialSecurity < ManyMembersStep
    def validate_household_member(member)
      member.valid?
      member.errors[:ssn].blank?
    end
  end
end
