class ManyMembersStep < Step
  step_attributes :members

  validate :members_valid

  def members_valid
    members.each do |member|
      member.errors.clear
      validate_household_member(member)
    end

    return true if members.map(&:errors).all?(&:blank?)
    errors.add(:members)
  end

  private

  def validate_household_member(_member)
    raise NotImplementedError
  end
end
