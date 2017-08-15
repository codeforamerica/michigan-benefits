# frozen_string_literal: true

class IncomeEmploymentStatus < Step
  step_attributes :members

  def valid?
    members.each do |member|
      member.errors.clear
      validate_household_member(member)
    end

    members.map(&:errors).all?(&:blank?)
  end

  def validate_household_member(member)
    return if member.employment_status.present?
    member.errors.add(:employment_status, "Make sure you answer this question")
  end
end
