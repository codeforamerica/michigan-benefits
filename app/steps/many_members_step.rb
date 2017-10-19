# frozen_string_literal: true

class ManyMembersStep < Step
  step_attributes :members

  def valid?
    members.each do |member|
      member.errors.clear
      validate_household_member(member)
    end

    members.map(&:errors).all?(&:blank?)
  end

  private

  def validate_household_member(_member)
    raise NotImplementedError
  end
end
