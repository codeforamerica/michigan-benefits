# frozen_string_literal: true

class IncomeCurrentlyEmployed < Step
  step_attributes :household_members

  def valid?
    household_members.each do |member|
      member.errors.clear
      validate_household_member(member)
    end

    household_members.map(&:errors).all?(&:blank?)
  end

  def validate_household_member(member)
    if member.employment_status.blank?
      member.errors.add(:employment_status, 'Make sure you answer this question')
    end
  end
end
