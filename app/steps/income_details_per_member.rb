class IncomeDetailsPerMember < ManyMembersStep
  private

  def validate_household_member(member)
    if member.employment_status == "employed" &&
        member.employed_employer_name.blank?
      member.errors.add(
        "employed_employer_name",
        "Make sure to answer this question",
      )
    end
  end
end
