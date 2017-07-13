# frozen_string_literal: true

class IncomeCurrentlyEmployed < ManyMemberSimpleStep
  step_attributes :household_members

  def validate_household_member(member)
    if member.employment_status.blank?
      member.errors.add(:employment_status, 'Make sure you answer this question')
    end
  end
end
