class IncomeEmploymentStatus < ManyMembersStep
  private

  def validate_household_member(member)
    return if member.employment_status.present?
    member.errors.add(:employment_status, "Make sure you answer this question")
  end
end
