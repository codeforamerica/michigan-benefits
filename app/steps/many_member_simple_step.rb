# frozen_string_literal: true

class ManyMemberSimpleStep < SimpleStep
  def valid?
    household_members.each do |member|
      member.errors.clear
      validate_household_member(member)
    end

    household_members.map(&:errors).all(&:blank?)
  end

  def validate_household_member(household_member); end
end
